{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.extra) mkBoolOption mkEnableOption;

  cfg = config.modules.services.lgtm;
in {
  options.modules.services.lgtm = {
    enable = mkEnableOption "Enables LGTM stack";
  };

  config = mkIf cfg.enable {
    services = {
      loki = {
        enable = true;
        configFile = pkgs.writeText "loki-config.yaml" ''
          auth_enabled: false

          server:
            http_listen_port: 3100

          common:
            path_prefix: /tmp/loki
            storage:
              filesystem:
                chunks_directory: /tmp/loki/chunks
                rules_directory: /tmp/loki/rules
            replication_factor: 1
            ring:
              kvstore:
                store: inmemory

          schema_config:
            configs:
              - from: 2020-10-24
                store: tsdb
                object_store: filesystem
                schema: v13
                index:
                  prefix: index_
                  period: 24h

          ruler:
            alertmanager_url: http://localhost:9093

          limits_config:
            allow_structured_metadata: true
        '';
      };

      grafana = {
        enable = true;
        settings = {};

        provision.datasources.path = pkgs.writeText "grafana-datasources.yaml" ''
          apiVersion: 1

          datasources:

            - name: Prometheus
              type: prometheus
              uid: prometheus
              url: http://localhost:9090
              jsonData:
                timeInterval: 60s
                exemplarTraceIdDestinations:
                  - name: traceID
                    datasourceUid: tempo
                    urlDisplayLabel: 'Trace: $${__value.raw}'

            - name: Tempo
              type: tempo
              uid: tempo
              url: http://localhost:3200
              jsonData:
                tracesToLogsV2:
                  customQuery: true
                  datasourceUid: 'loki'
                  query: '{$${__tags}} | trace_id = "$${__trace.traceId}"'
                  tags:
                    - key: 'service.name'
                      value: 'service_name'

                serviceMap:
                  datasourceUid: 'prometheus'
                search:
                  hide: false
                nodeGraph:
                  enabled: true
                lokiSearch:
                  datasourceUid: 'loki'

            - name: Loki
              type: loki
              uid: loki
              url: http://localhost:3100
              jsonData:
                derivedFields:
                  - name: 'trace_id'
                    matcherType: 'label'
                    matcherRegex: 'trace_id'
                    url: '$${__value.raw}'
                    datasourceUid: 'tempo'
                    urlDisplayLabel: 'Trace: $${__value.raw}'
        '';
      };

      tempo = {
        enable = true;
        configFile = pkgs.writeText "tempo-config.yaml" ''
          server:
            http_listen_port: 3200
            grpc_listen_port: 9096

          distributor:
            receivers:
              otlp:
                protocols:
                  grpc:
                    endpoint: "localhost:4417"
                  http:
                    endpoint: "localhost:4418"

          storage:
            trace:
              backend: local
              wal:
                path: /tmp/tempo/wal
              local:
                path: /tmp/tempo/blocks

          metrics_generator:
            processor:
              local_blocks:
                filter_server_spans: false
            traces_storage:
              path: /tmp/tempo/generator/traces
            storage:
              path: /tmp/tempo/generator/wal
              # TODO: support otlp at metrics_generator
              remote_write:
                - url: http://localhost:9090/api/v1/write
                  send_exemplars: true

          overrides:
            metrics_generator_processors: [service-graphs, local-blocks]
        '';
      };

      prometheus = {
        enable = true;
        configText = ''
          storage:
            tsdb:
              # A 10min time window is enough because it can easily absorb retries and network delays.
              out_of_order_time_window: 10m
        '';
        extraFlags = [
          "--web.enable-remote-write-receiver"
          "--enable-feature=otlp-write-receiver"
          "--enable-feature=exemplar-storage"
          "--enable-feature=native-histograms"
        ];
      };

      opentelemetry-collector = {
        enable = true;
        configFile = pkgs.writeText "otel-config.yaml" ''
          receivers:
            otlp:
              protocols:
                grpc:
                http:
            # prometheus/collector:
            #   config:
            #     scrape_configs:
            #       - job_name: 'opentelemetry-collector'
            #         static_configs:
            #           - targets: ['localhost:8888']

          processors:
            batch:

          exporters:
            otlphttp/metrics:
              endpoint: http://localhost:9090/api/v1/otlp
              tls:
                insecure: true
            otlphttp/traces:
              endpoint: http://localhost:4418
              tls:
                insecure: true
            otlphttp/logs:
              endpoint: http://localhost:3100/otlp/v1/logs
              tls:
                insecure: true
            logging/metrics:
              verbosity: detailed
            logging/traces:
              verbosity: detailed
            logging/logs:
              verbosity: detailed

          service:
            pipelines:
              traces:
                receivers: [otlp]
                processors: [batch]
                # exporters: [otlphttp/traces]
                exporters: [otlphttp/traces,logging/traces]
              metrics:
                receivers: [otlp]
                processors: [batch]
                # exporters: [otlphttp/metrics]
                exporters: [otlphttp/metrics,logging/metrics]
              logs:
                receivers: [otlp]
                processors: [batch]
                # exporters: [otlphttp/logs]
                exporters: [otlphttp/logs,logging/logs]
        '';
      };
    };
  };
}
