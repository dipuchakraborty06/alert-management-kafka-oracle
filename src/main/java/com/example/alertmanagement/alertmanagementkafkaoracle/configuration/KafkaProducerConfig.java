package com.example.alertmanagement.alertmanagementkafkaoracle.configuration;

import java.util.HashMap;
import java.util.Map;

import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

import com.example.alertmanagement.alertmanagementkafkaoracle.dto.AlertMessage;
import com.example.alertmanagement.alertmanagementkafkaoracle.rest.KafkaController;

@Configuration
@Import({ KafkaController.class })
public class KafkaProducerConfig {
	
	@Value("${spring.kafka.bootstrap-servers}")
	private String BOOTSTRAP_SERVERS;
	
	@Value("${spring.kafka.properties.security.protocol}")
	private String SECURITY_PROTOCOL;
	
	@Value("${spring.kafka.properties.sasl.mechanism}")
	private String SASL_MECHANISM;
	
	@Value("${spring.kafka.properties.sasl.jaas.config}")
	private String SASL_JAAS_CONFIG;
	
	@Bean
	public ProducerFactory<String, AlertMessage> producerFactory()
	{
		Map<String, Object> configurationProperties = new HashMap<String, Object>();
		configurationProperties.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
		configurationProperties.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
		configurationProperties.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
		configurationProperties.put("security.protocol", SECURITY_PROTOCOL);
		configurationProperties.put("sasl.mechanism", SASL_MECHANISM);
		configurationProperties.put("sasl.jaas.config", SASL_JAAS_CONFIG);
		
		return new DefaultKafkaProducerFactory<String, AlertMessage>(configurationProperties);
	}
	
	@Bean
	public KafkaTemplate<String, AlertMessage> kafkaTemplate()
	{
		return new KafkaTemplate(producerFactory());
	}
}
