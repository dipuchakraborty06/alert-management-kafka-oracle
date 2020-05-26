package com.example.alertmanagement.alertmanagementkafkaoracle.configuration;

import java.util.HashMap;
import java.util.Map;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;
import com.example.alertmanagement.alertmanagementkafkaoracle.dto.AlertMessage;


@Configuration
public class KafkaConfig {
	@Bean
	public ProducerFactory<String, AlertMessage> producerFactory(){
		Map<String, Object> configuration = new HashMap<String, Object>();
		configuration.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka-server-1:9092,kafka-server-2");
		configuration.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
		configuration.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
		return new DefaultKafkaProducerFactory<String, AlertMessage>(configuration);
	}
	
	@Bean
	public KafkaTemplate<String, AlertMessage> kafkaTemplate(){
		return new KafkaTemplate<String, AlertMessage>(producerFactory());
	}
}
