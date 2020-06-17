package com.example.alertmanagement.alertmanagementkafkaoracle.handler;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.time.Instant;
import java.util.logging.Handler;

import com.amazonaws.serverless.proxy.model.AwsProxyRequest;
import com.amazonaws.serverless.proxy.model.AwsProxyResponse;
import com.amazonaws.serverless.proxy.spring.SpringBootLambdaContainerHandler;
import com.amazonaws.serverless.proxy.spring.SpringBootProxyHandlerBuilder;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.example.alertmanagement.alertmanagementkafkaoracle.AlertManagementKafkaOracleApplication;

public class AlertManagementKafkaOracleHandler implements RequestStreamHandler {
	private static SpringBootLambdaContainerHandler<AwsProxyRequest, AwsProxyResponse> handler;
	
	static {
		try {
			handler = SpringBootLambdaContainerHandler.getAwsProxyHandler(AlertManagementKafkaOracleApplication.class);
		}
		catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Could not intialize spring boot application",e);
		}
	}
	@Override
	public void handleRequest(InputStream input, OutputStream output, Context context) throws IOException {
		handler.proxyStream(input, output, context);
	}

}
