package com.force.example.fulfillment.order.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.validation.Validator;

@Controller
@RequestMapping(value="/s1mp")
public class S1MobileCardPreviewController {

    @Autowired
    public S1MobileCardPreviewController(Validator validator) {
    }

    @RequestMapping(method= RequestMethod.GET)
    public String getPage() {
        return "s1mp";
    }

}