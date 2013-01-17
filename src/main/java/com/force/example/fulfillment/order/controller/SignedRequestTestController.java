package com.force.example.fulfillment.order.controller;

import javax.validation.Validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value="/sr")
public class SignedRequestTestController {

	@Autowired
	public SignedRequestTestController(Validator validator) {
	}

	@RequestMapping(method=RequestMethod.GET)
	public String getPage() {
        return "sr";
	}
}
