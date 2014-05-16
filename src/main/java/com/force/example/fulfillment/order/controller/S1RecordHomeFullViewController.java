package com.force.example.fulfillment.order.controller;

import com.force.example.fulfillment.order.model.Order;
import com.force.example.fulfillment.order.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolation;
import javax.validation.Valid;
import javax.validation.Validator;
import java.util.*;

@Controller
@RequestMapping(value="/s1rf")
public class S1RecordHomeFullViewController {

    @Autowired
    private OrderService orderService;

    private Validator validator;

    @Autowired
    public S1RecordHomeFullViewController(Validator validator) {
    }

    @RequestMapping(method= RequestMethod.GET)
    public String getPage() {
        return "s1rf";
    }

}