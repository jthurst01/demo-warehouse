package com.force.example.fulfillment.order.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
@RequestMapping(value="/s1rp")
public class S1MobileCardPreviewController {

    @Autowired
    public S1MobileCardPreviewController() {
    }

    @RequestMapping(method= RequestMethod.GET)
    public String getPage() {
        return "s1mp";
    }

}