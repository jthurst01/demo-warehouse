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

import java.util.Map;

@Controller
@RequestMapping(value="/orderui")
public class OrderUIController {

    private static final String SIGNED_REQUEST = "signedRequestJson";
    private CanvasContext cc = new CanvasContext();

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
        cc = cr.getContext();
        CanvasEnvironmentContext ce = cc.getEnvironmentContext();
        //Map<String, Object> params = ce.getParameters();
        //if (params != null) {
        //    String orderId = (String)params.get("orderId");
        //    if(orderId != null) {
        //        return getOrderPage(orderId, model);
        //    }
        //}
        String subLocation = ce.getSublocation();
        Map<String, Object> record = ce.getRecord();
        System.out.println("record: " + record);
        if (record != null) {
            String orderId = (String)record.get("Id");
            System.out.println("orderId: " + orderId);
            if(orderId != null) {
                System.out.println("subLocation: " + subLocation);
                return getOrderPage(orderId, subLocation, model);
            }
        }
        return getOrdersPage(model);
    }

    @RequestMapping(method=RequestMethod.GET)
    public String getOrdersPage(Model model) {
        model.addAttribute("order", new Order());
        model.addAttribute("orders", orderService.listOrders(cc.getOrganizationContext().getOrganizationId()));
        return "orders";
    }

	@RequestMapping(value="{id}", method=RequestMethod.GET)
	public String getOrderPage(@PathVariable String id, String subLocation, Model model) {
		Order order = orderService.findOrder(id);
		if (order == null) {
			//throw new ResourceNotFoundException(id);
            model.addAttribute("ordernf", order);
            return "ordernf";
		}
		model.addAttribute("order", order);
        if (subLocation == "S1RecordHomePreview") {
            //throw new ResourceNotFoundException(id);
            model.addAttribute("s1rp", order);
            return "s1rp";
        }

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
