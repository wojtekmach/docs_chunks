searchNodes=[{"doc":"","ref":"brod.html","title":"brod","type":"module"},{"doc":"Connect to consumer group coordinator broker. Done in steps: 1) connect to any of the given bootstrap ednpoints; 2) send group_coordinator_request to resolve group coordinator endpoint;; 3) connect to the resolved endpoint and return the connection pid","ref":"brod.html#connect_group_coordinator/3","title":"brod.connect_group_coordinator/3","type":"function"},{"doc":"Connect partition leader.","ref":"brod.html#connect_leader/4","title":"brod.connect_leader/4","type":"function"},{"doc":"","ref":"brod.html#consume_ack/2","title":"brod.consume_ack/2","type":"function"},{"doc":"","ref":"brod.html#consume_ack/4","title":"brod.consume_ack/4","type":"function"},{"doc":"Equivalent to create_topics(Hosts, TopicsConfigs, RequestConfigs, []).","ref":"brod.html#create_topics/3","title":"brod.create_topics/3","type":"function"},{"doc":"Create topic(s) in kafka Return the message body of create_topics, response. See kpro_schema.erl for struct details","ref":"brod.html#create_topics/4","title":"brod.create_topics/4","type":"function"},{"doc":"Equivalent to delete_topics(Hosts, Topics, Timeout, []).","ref":"brod.html#delete_topics/3","title":"brod.delete_topics/3","type":"function"},{"doc":"Delete topic(s) from kafka Return the message body of delete_topics, response. See kpro_schema.erl for struct details","ref":"brod.html#delete_topics/4","title":"brod.delete_topics/4","type":"function"},{"doc":"Describe consumer groups. The given consumer group IDs should be all managed by the coordinator-broker running at the given endpoint. Otherwise error codes will be returned in the result structs. Return describe_groups response body field named groups. See kpro_schema.erl for struct details","ref":"brod.html#describe_groups/3","title":"brod.describe_groups/3","type":"function"},{"doc":"Fetch a single message set from the given topic-partition. The first arg can either be an already established connection to leader, or {Endpoints, ConnConfig} so to establish a new connection before fetch.","ref":"brod.html#fetch/4","title":"brod.fetch/4","type":"function"},{"doc":"Fetch a single message set from the given topic-partition. The first arg can either be an already established connection to leader, or {Endpoints, ConnConfig} so to establish a new connection before fetch.","ref":"brod.html#fetch/5","title":"brod.fetch/5","type":"function"},{"doc":"","ref":"brod.html#fetch/7","title":"brod.fetch/7","type":"function"},{"doc":"","ref":"brod.html#fetch/8","title":"brod.fetch/8","type":"function"},{"doc":"Same as fetch_committed_offsets/3, but works with a started brod_client","ref":"brod.html#fetch_committed_offsets/2","title":"brod.fetch_committed_offsets/2","type":"function"},{"doc":"Fetch committed offsets for ALL topics in the given consumer group. Return the responses field of the offset_fetch response. See kpro_schema.erl for struct details.","ref":"brod.html#fetch_committed_offsets/3","title":"brod.fetch_committed_offsets/3","type":"function"},{"doc":"Fold through messages in a partition. Works like lists:foldl/2 but with below stop conditions: Always return after reach high watermark offset Return after the given message count limit is reached Return after the given kafka offset is reached. Return if the FoldFun returns an {error, Reason} tuple. NOTE: Exceptions from evaluating FoldFun are not caught.","ref":"brod.html#fold/8","title":"brod.fold/8","type":"function"},{"doc":"","ref":"brod.html#get_consumer/3","title":"brod.get_consumer/3","type":"function"},{"doc":"Fetch broker metadata Return the message body of metadata response. See kpro_schema.erl for details","ref":"brod.html#get_metadata/1","title":"brod.get_metadata/1","type":"function"},{"doc":"Fetch broker/topic metadata Return the message body of metadata response. See kpro_schema.erl for struct details","ref":"brod.html#get_metadata/2","title":"brod.get_metadata/2","type":"function"},{"doc":"Fetch broker/topic metadata Return the message body of metadata response. See kpro_schema.erl for struct details","ref":"brod.html#get_metadata/3","title":"brod.get_metadata/3","type":"function"},{"doc":"Get number of partitions for a given topic. The higher level producers may need the partition numbers to find the partition producer pid --- if the number of partitions is not statically configured for them. It is up to the callers how they want to distribute their data (e.g. random, roundrobin or consistent-hashing) to the partitions.","ref":"brod.html#get_partitions_count/2","title":"brod.get_partitions_count/2","type":"function"},{"doc":"Equivalent to brod_client:get_producer / 3.","ref":"brod.html#get_producer/3","title":"brod.get_producer/3","type":"function"},{"doc":"List ALL consumer groups in the given kafka cluster. NOTE: Exception if failed to connect any of the coordinator brokers.","ref":"brod.html#list_all_groups/2","title":"brod.list_all_groups/2","type":"function"},{"doc":"List consumer groups in the given group coordinator broker.","ref":"brod.html#list_groups/2","title":"brod.list_groups/2","type":"function"},{"doc":"Equivalent to produce(Pid, 0, &lt;&lt;&gt;&gt;, Value).","ref":"brod.html#produce/2","title":"brod.produce/2","type":"function"},{"doc":"Produce one message if Value is binary or iolist, Or send a batch if Value is a (nested) kv-list or a list of maps, in this case Key is discarded (only the keys in kv-list are sent to kafka). The pid should be a partition producer pid, NOT client pid. The return value is a call reference of type call_ref(), so the caller can used it to expect (match) a #brod_produce_reply{result = brod_produce_req_acked} message after the produce request has been acked by kafka.","ref":"brod.html#produce/3","title":"brod.produce/3","type":"function"},{"doc":"Produce one message if Value is binary or iolist, Or send a batch if Value is a (nested) kv-list or a list of maps, in this case Key is used only for partitioning, or discarded if the 3rd arg is a partition number instead of a partitioner callback. This function first lookup the producer pid, then call produce/3 to do the real work. The return value is a call reference of type call_ref(), so the caller can used it to expect (match) a #brod_produce_reply{result = brod_produce_req_acked} message after the produce request has been acked by kafka.","ref":"brod.html#produce/5","title":"brod.produce/5","type":"function"},{"doc":"Same as produce/3 only the ack is not delivered as a message, instead, the callback is evaluated by producer worker when ack is received from kafka.","ref":"brod.html#produce_cb/4","title":"brod.produce_cb/4","type":"function"},{"doc":"Same as produce/5 only the ack is not delivered as a message, instead, the callback is evaluated by producer worker when ack is received from kafka. Return the partition to caller as {ok, Partition} for caller to correlate the callback when the 3rd arg is not a partition number.","ref":"brod.html#produce_cb/6","title":"brod.produce_cb/6","type":"function"},{"doc":"Find the partition worker and send message without any ack. NOTE: This call has no back-pressure to the caller, excessive usage may cause beam to run out of memory.","ref":"brod.html#produce_no_ack/5","title":"brod.produce_no_ack/5","type":"function"},{"doc":"Equivalent to produce_sync(Pid, 0, &lt;&lt;&gt;&gt;, Value).","ref":"brod.html#produce_sync/2","title":"brod.produce_sync/2","type":"function"},{"doc":"Sync version of produce/3 This function will not return until a response is received from kafka, however if producer is started with required_acks set to 0, this function will return onece the messages is buffered in the producer process.","ref":"brod.html#produce_sync/3","title":"brod.produce_sync/3","type":"function"},{"doc":"Sync version of produce/5 This function will not return until a response is received from kafka, however if producer is started with required_acks set to 0, this function will return once the messages are buffered in the producer process.","ref":"brod.html#produce_sync/5","title":"brod.produce_sync/5","type":"function"},{"doc":"Version of produce_sync/5 that returns the offset assigned by Kafka If producer is started with required_acks set to 0, the offset will be ?BROD_PRODUCE_UNKNOWN_OFFSET.","ref":"brod.html#produce_sync_offset/5","title":"brod.produce_sync_offset/5","type":"function"},{"doc":"Equivalent to resolve_offset(Hosts, Topic, Partition, latest, 1).","ref":"brod.html#resolve_offset/3","title":"brod.resolve_offset/3","type":"function"},{"doc":"Resolve semantic offset or timestamp to real offset.","ref":"brod.html#resolve_offset/4","title":"brod.resolve_offset/4","type":"function"},{"doc":"Resolve semantic offset or timestamp to real offset.","ref":"brod.html#resolve_offset/5","title":"brod.resolve_offset/5","type":"function"},{"doc":"Start brod application.","ref":"brod.html#start/0","title":"brod.start/0","type":"function"},{"doc":"Application behaviour callback","ref":"brod.html#start/2","title":"brod.start/2","type":"function"},{"doc":"Equivalent to start_client(BootstrapEndpoints, brod_default_client).","ref":"brod.html#start_client/1","title":"brod.start_client/1","type":"function"},{"doc":"Equivalent to start_client(BootstrapEndpoints, ClientId, []).","ref":"brod.html#start_client/2","title":"brod.start_client/2","type":"function"},{"doc":"Start a client. BootstrapEndpoints: Kafka cluster endpoints, can be any of the brokers in the cluster which does not necessarily have to be a leader of any partition, e.g. a load-balanced entrypoint to the remote kakfa cluster. ClientId: Atom to identify the client process. Config is a proplist, possible values: restart_delay_seconds (optional, default=10) How much time to wait between attempts to restart brod_client process when it crashes get_metadata_timeout_seconds (optional, default=5) Return {error, timeout} from brod_client:get_xxx calls if responses for APIs such as metadata, find_coordinator is not received in time. reconnect_cool_down_seconds (optional, default=1) Delay this configured number of seconds before retrying to estabilish a new connection to the kafka partition leader. allow_topic_auto_creation (optional, default=true) By default, brod respects what is configured in broker about topic auto-creation. i.e. whatever auto.create.topics.enable is set in broker configuration. However if allow_topic_auto_creation is set to false in client config, brod will avoid sending metadata requests that may cause an auto-creation of the topic regardless of what broker config is. auto_start_producers (optional, default=false) If true, brod client will spawn a producer automatically when user is trying to call produce but did not call brod:start_producer explicitly. Can be useful for applications which don&#39;t know beforehand which topics they will be working with. default_producer_config (optional, default=[]) Producer configuration to use when auto_start_producers is true.","ref":"brod.html#start_client/3","title":"brod.start_client/3","type":"function"},{"doc":"Dynamically start a topic consumer.","ref":"brod.html#start_consumer/3","title":"brod.start_consumer/3","type":"function"},{"doc":"Equivalent to start_link_client(BootstrapEndpoints, brod_default_client).","ref":"brod.html#start_link_client/1","title":"brod.start_link_client/1","type":"function"},{"doc":"Equivalent to start_link_client(BootstrapEndpoints, ClientId, []).","ref":"brod.html#start_link_client/2","title":"brod.start_link_client/2","type":"function"},{"doc":"","ref":"brod.html#start_link_client/3","title":"brod.start_link_client/3","type":"function"},{"doc":"Equivalent to brod_group_subscriber:start_link / 7.","ref":"brod.html#start_link_group_subscriber/7","title":"brod.start_link_group_subscriber/7","type":"function"},{"doc":"Equivalent to brod_group_subscriber:start_link / 8.","ref":"brod.html#start_link_group_subscriber/8","title":"brod.start_link_group_subscriber/8","type":"function"},{"doc":"Start group_subscriber_v2","ref":"brod.html#start_link_group_subscriber_v2/1","title":"brod.start_link_group_subscriber_v2/1","type":"function"},{"doc":"Equivalent to start_link_topic_subscriber(Client, Topic, all, ConsumerConfig, CbModule, CbInitArg).","ref":"brod.html#start_link_topic_subscriber/5","title":"brod.start_link_topic_subscriber/5","type":"function"},{"doc":"Equivalent to start_link_topic_subscriber(Client, Topic, Partitions, ConsumerConfig, message, CbModule, CbInitArg).","ref":"brod.html#start_link_topic_subscriber/6","title":"brod.start_link_topic_subscriber/6","type":"function"},{"doc":"Equivalent to brod_topic_subscriber:start_link / 7.","ref":"brod.html#start_link_topic_subscriber/7","title":"brod.start_link_topic_subscriber/7","type":"function"},{"doc":"Dynamically start a per-topic producer.","ref":"brod.html#start_producer/3","title":"brod.start_producer/3","type":"function"},{"doc":"Stop brod application.","ref":"brod.html#stop/0","title":"brod.stop/0","type":"function"},{"doc":"Application behaviour callback","ref":"brod.html#stop/1","title":"brod.stop/1","type":"function"},{"doc":"Stop a client.","ref":"brod.html#stop_client/1","title":"brod.stop_client/1","type":"function"},{"doc":"","ref":"brod.html#subscribe/3","title":"brod.subscribe/3","type":"function"},{"doc":"Subscribe data stream from the given topic-partition. If {error, Reason} is returned, the caller should perhaps retry later. {ok, ConsumerPid} is returned if success, the caller may want to monitor the consumer pid to trigger a re-subscribe in case it crashes. If subscribed successfully, the subscriber process should expect messages of pattern: {ConsumerPid, #kafka_message_set{}} and {ConsumerPid, #kafka_fetch_error{}}, -include_lib(brod/include/brod.hrl) to access the records. In case #kafka_fetch_error{} is received the subscriber should re-subscribe itself to resume the data stream.","ref":"brod.html#subscribe/5","title":"brod.subscribe/5","type":"function"},{"doc":"Block wait for sent produced request to be acked by kafka.","ref":"brod.html#sync_produce_request/1","title":"brod.sync_produce_request/1","type":"function"},{"doc":"","ref":"brod.html#sync_produce_request/2","title":"brod.sync_produce_request/2","type":"function"},{"doc":"As sync_produce_request_offset/1, but also returning assigned offset See produce_sync_offset/5.","ref":"brod.html#sync_produce_request_offset/1","title":"brod.sync_produce_request_offset/1","type":"function"},{"doc":"","ref":"brod.html#sync_produce_request_offset/2","title":"brod.sync_produce_request_offset/2","type":"function"},{"doc":"Unsubscribe the current subscriber. Assuming the subscriber is self().","ref":"brod.html#unsubscribe/1","title":"brod.unsubscribe/1","type":"function"},{"doc":"Unsubscribe the current subscriber.","ref":"brod.html#unsubscribe/2","title":"brod.unsubscribe/2","type":"function"},{"doc":"Unsubscribe the current subscriber. Assuming the subscriber is self().","ref":"brod.html#unsubscribe/3","title":"brod.unsubscribe/3","type":"function"},{"doc":"Unsubscribe the current subscriber.","ref":"brod.html#unsubscribe/4","title":"brod.unsubscribe/4","type":"function"},{"doc":"","ref":"brod.html#t:batch_input/0","title":"brod.batch_input/0","type":"type"},{"doc":"","ref":"brod.html#t:bootstrap/0","title":"brod.bootstrap/0","type":"type"},{"doc":"","ref":"brod.html#t:call_ref/0","title":"brod.call_ref/0","type":"type"},{"doc":"","ref":"brod.html#t:cg/0","title":"brod.cg/0","type":"type"},{"doc":"","ref":"brod.html#t:cg_protocol_type/0","title":"brod.cg_protocol_type/0","type":"type"},{"doc":"","ref":"brod.html#t:client/0","title":"brod.client/0","type":"type"},{"doc":"","ref":"brod.html#t:client_config/0","title":"brod.client_config/0","type":"type"},{"doc":"","ref":"brod.html#t:client_id/0","title":"brod.client_id/0","type":"type"},{"doc":"","ref":"brod.html#t:compression/0","title":"brod.compression/0","type":"type"},{"doc":"","ref":"brod.html#t:conn_config/0","title":"brod.conn_config/0","type":"type"},{"doc":"","ref":"brod.html#t:connection/0","title":"brod.connection/0","type":"type"},{"doc":"","ref":"brod.html#t:consumer_config/0","title":"brod.consumer_config/0","type":"type"},{"doc":"","ref":"brod.html#t:consumer_option/0","title":"brod.consumer_option/0","type":"type"},{"doc":"","ref":"brod.html#t:consumer_options/0","title":"brod.consumer_options/0","type":"type"},{"doc":"","ref":"brod.html#t:endpoint/0","title":"brod.endpoint/0","type":"type"},{"doc":"","ref":"brod.html#t:error_code/0","title":"brod.error_code/0","type":"type"},{"doc":"","ref":"brod.html#t:fetch_opts/0","title":"brod.fetch_opts/0","type":"type"},{"doc":"","ref":"brod.html#t:fold_acc/0","title":"brod.fold_acc/0","type":"type"},{"doc":"fold always returns when reaches the high watermark offset fold also returns when any of the limits is hit","ref":"brod.html#t:fold_fun/1","title":"brod.fold_fun/1","type":"type"},{"doc":"","ref":"brod.html#t:fold_limits/0","title":"brod.fold_limits/0","type":"type"},{"doc":"","ref":"brod.html#t:fold_result/0","title":"brod.fold_result/0","type":"type"},{"doc":"OffsetToContinue: begin offset for the next fold call","ref":"brod.html#t:fold_stop_reason/0","title":"brod.fold_stop_reason/0","type":"type"},{"doc":"","ref":"brod.html#t:group_config/0","title":"brod.group_config/0","type":"type"},{"doc":"","ref":"brod.html#t:group_generation_id/0","title":"brod.group_generation_id/0","type":"type"},{"doc":"","ref":"brod.html#t:group_id/0","title":"brod.group_id/0","type":"type"},{"doc":"","ref":"brod.html#t:group_member/0","title":"brod.group_member/0","type":"type"},{"doc":"","ref":"brod.html#t:group_member_id/0","title":"brod.group_member_id/0","type":"type"},{"doc":"","ref":"brod.html#t:hostname/0","title":"brod.hostname/0","type":"type"},{"doc":"","ref":"brod.html#t:key/0","title":"brod.key/0","type":"type"},{"doc":"","ref":"brod.html#t:message/0","title":"brod.message/0","type":"type"},{"doc":"","ref":"brod.html#t:message_set/0","title":"brod.message_set/0","type":"type"},{"doc":"","ref":"brod.html#t:msg_input/0","title":"brod.msg_input/0","type":"type"},{"doc":"","ref":"brod.html#t:msg_ts/0","title":"brod.msg_ts/0","type":"type"},{"doc":"","ref":"brod.html#t:offset/0","title":"brod.offset/0","type":"type"},{"doc":"","ref":"brod.html#t:offset_time/0","title":"brod.offset_time/0","type":"type"},{"doc":"","ref":"brod.html#t:partition/0","title":"brod.partition/0","type":"type"},{"doc":"","ref":"brod.html#t:partition_assignment/0","title":"brod.partition_assignment/0","type":"type"},{"doc":"","ref":"brod.html#t:partition_fun/0","title":"brod.partition_fun/0","type":"type"},{"doc":"","ref":"brod.html#t:partitioner/0","title":"brod.partitioner/0","type":"type"},{"doc":"","ref":"brod.html#t:portnum/0","title":"brod.portnum/0","type":"type"},{"doc":"","ref":"brod.html#t:produce_ack_cb/0","title":"brod.produce_ack_cb/0","type":"type"},{"doc":"","ref":"brod.html#t:produce_reply/0","title":"brod.produce_reply/0","type":"type"},{"doc":"","ref":"brod.html#t:produce_result/0","title":"brod.produce_result/0","type":"type"},{"doc":"","ref":"brod.html#t:producer_config/0","title":"brod.producer_config/0","type":"type"},{"doc":"","ref":"brod.html#t:received_assignments/0","title":"brod.received_assignments/0","type":"type"},{"doc":"","ref":"brod.html#t:topic/0","title":"brod.topic/0","type":"type"},{"doc":"","ref":"brod.html#t:topic_config/0","title":"brod.topic_config/0","type":"type"},{"doc":"","ref":"brod.html#t:topic_partition/0","title":"brod.topic_partition/0","type":"type"},{"doc":"","ref":"brod.html#t:value/0","title":"brod.value/0","type":"type"},{"doc":"This is a utility module to help force commit offsets to kafka.","ref":"brod_cg_commits.html","title":"brod_cg_commits","type":"module"},{"doc":"This function is called only when partition_assignment_strategy is set for callback_implemented in group config.","ref":"brod_cg_commits.html#assign_partitions/3","title":"brod_cg_commits.assign_partitions/3","type":"function"},{"doc":"Called by group coordinator when there is new assignemnt received.","ref":"brod_cg_commits.html#assignments_received/4","title":"brod_cg_commits.assignments_received/4","type":"function"},{"doc":"Called by group coordinator before re-joinning the consumer group.","ref":"brod_cg_commits.html#assignments_revoked/1","title":"brod_cg_commits.assignments_revoked/1","type":"function"},{"doc":"Callback implementation for c::gen_server.code_change/3.","ref":"brod_cg_commits.html#code_change/3","title":"brod_cg_commits.code_change/3","type":"function"},{"doc":"Called by group coordinator when initializing the assignments for subscriber. NOTE: this function is called only when it is DISABLED to commit offsets to kafka. i.e. offset_commit_policy is set to consumer_managed","ref":"brod_cg_commits.html#get_committed_offsets/2","title":"brod_cg_commits.get_committed_offsets/2","type":"function"},{"doc":"Callback implementation for c::gen_server.handle_call/3.","ref":"brod_cg_commits.html#handle_call/3","title":"brod_cg_commits.handle_call/3","type":"function"},{"doc":"Callback implementation for c::gen_server.handle_cast/2.","ref":"brod_cg_commits.html#handle_cast/2","title":"brod_cg_commits.handle_cast/2","type":"function"},{"doc":"Callback implementation for c::gen_server.handle_info/2.","ref":"brod_cg_commits.html#handle_info/2","title":"brod_cg_commits.handle_info/2","type":"function"},{"doc":"Callback implementation for c::gen_server.init/1.","ref":"brod_cg_commits.html#init/1","title":"brod_cg_commits.init/1","type":"function"},{"doc":"Force commit offsets.","ref":"brod_cg_commits.html#run/2","title":"brod_cg_commits.run/2","type":"function"},{"doc":"Start (link) a group member. The member will try to join the consumer group and get assignments for the given topic-partitions, then commit given offsets to kafka. In case not all given partitions are assigned to it, it will terminate with an exit exception","ref":"brod_cg_commits.html#start_link/2","title":"brod_cg_commits.start_link/2","type":"function"},{"doc":"Stop the process.","ref":"brod_cg_commits.html#stop/1","title":"brod_cg_commits.stop/1","type":"function"},{"doc":"Make a call to the resetter process, the call will be blocked until offsets are committed.","ref":"brod_cg_commits.html#sync/1","title":"brod_cg_commits.sync/1","type":"function"},{"doc":"Callback implementation for c::gen_server.terminate/2.","ref":"brod_cg_commits.html#terminate/2","title":"brod_cg_commits.terminate/2","type":"function"},{"doc":"","ref":"brod_cg_commits.html#t:group_id/0","title":"brod_cg_commits.group_id/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:group_input/0","title":"brod_cg_commits.group_input/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:member_id/0","title":"brod_cg_commits.member_id/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:offset/0","title":"brod_cg_commits.offset/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:offsets/0","title":"brod_cg_commits.offsets/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:partition/0","title":"brod_cg_commits.partition/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:prop_key/0","title":"brod_cg_commits.prop_key/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:prop_val/0","title":"brod_cg_commits.prop_val/0","type":"type"},{"doc":"-1 to use whatever configured in kafka","ref":"brod_cg_commits.html#t:retention/0","title":"brod_cg_commits.retention/0","type":"type"},{"doc":"","ref":"brod_cg_commits.html#t:topic/0","title":"brod_cg_commits.topic/0","type":"type"},{"doc":"","ref":"brod_cli.html","title":"brod_cli","type":"module"}]