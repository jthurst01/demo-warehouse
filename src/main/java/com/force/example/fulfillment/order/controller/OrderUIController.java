package com.force.example.fulfillment.order.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Validator;

import canvas.CanvasContext;
import canvas.CanvasEnvironmentContext;
import canvas.CanvasRequest;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import canvas.SignedRequest;

import com.force.example.fulfillment.order.model.Order;
import com.force.example.fulfillment.order.service.OrderService;

@Controller
@RequestMapping(value="/orderui")
public class OrderUIController {

    private static final String SIGNED_REQUEST = "signedRequestJson";

	@Autowired
	private OrderService orderService;

	private Validator validator;

	@Autowired
	public OrderUIController(Validator validator) {
		this.validator = validator;
	}

	@RequestMapping(method=RequestMethod.POST)
	public String postSignedRequest(Model model,@RequestParam(value="signed_request")String signedRequest, HttpServletRequest request){
	    String srJson = SignedRequest.verifyAndDecodeAsJson(signedRequest, getConsumerSecret());
        CanvasRequest cr = SignedRequest.verifyAndDecode(signedRequest, getConsumerSecret());
        HttpSession session = request.getSession(true);
        session.setAttribute(SIGNED_REQUEST, srJson);
        CanvasContext cc = cr.getContext();
        CanvasEnvironmentContext ce = cc.getEnvironmentContext();
        System.out.println("=====Canvas Environment: " + ce.toString());
        System.out.println("=====Parameters: " + ce.getSRParameters().toString());
        if(ce.getSRParameters() == null) {
            System.out.println("=====In Null");
            return getOrdersPage(model);
        } else {
            System.out.println("=====In Not Null");
            return getOrderPage(ce.getSRParameters().toString(), model);
        }
	}

    @RequestMapping(method=RequestMethod.GET)
    public String getOrdersPage(Model model) {
        System.out.println("=====In getOrdersPage");
        model.addAttribute("order", new Order());
        model.addAttribute("orders", orderService.listOrders());
        return "orders";
    }

	@RequestMapping(value="{id}", method=RequestMethod.GET)
	public String getOrderPage(@PathVariable String id, Model model) {
        System.out.println("=====In getOrderPage");
		Order order = orderService.findOrder(id);
		if (order == null) {
			//throw new ResourceNotFoundException(id);
            model.addAttribute("ordernf", order);
            return "ordernf";
		}
		model.addAttribute("order", order);

		return "order";
	}

	private static final String getConsumerSecret(){
	    String secret = System.getenv("CANVAS_CONSUMER_SECRET");
	    if (null == secret){
	        throw new IllegalStateException("Consumer secret not found in environment.  You must define the CANVAS_CONSUMER_SECRET environment variable.");
	    }
	    return secret;
	}
}
