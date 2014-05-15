package com.force.example.fulfillment.order.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	String resourceId;

	public ResourceNotFoundException(String resourceId) {
		this.resourceId = resourceId;
	}

}
