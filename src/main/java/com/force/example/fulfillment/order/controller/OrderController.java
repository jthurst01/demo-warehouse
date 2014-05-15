package com.force.example.fulfillment.order.controller;

import java.util.*;
import java.util.List;
import java.util.concurrent.atomic.AtomicReferenceArray;

import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolation;
import javax.validation.Valid;
import javax.validation.Validator;

import com.force.example.fulfillment.order.model.LineItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.force.example.fulfillment.order.model.Order;
import com.force.example.fulfillment.order.service.OrderService;
//my small change

@Controller 
@RequestMapping(value="/order")
public class OrderController {

	@Autowired
	private OrderService orderService;

	private Validator validator;

	@Autowired
	public OrderController(Validator validator) {
		this.validator = validator;
	}

	@RequestMapping(method=RequestMethod.POST)
	public @ResponseBody List<? extends Object> create(@Valid @RequestBody Order[] orders, HttpServletResponse response) {
		boolean failed = false;
        Order[] newOrder = new Order[1];
		List<Map<String, String>> failureList = new LinkedList<Map<String, String>>();
		for (Order order: orders) {
			Set<ConstraintViolation<Order>> failures = validator.validate(order);
			if (failures.isEmpty()) {
				Map<String, String> failureMessageMap = new HashMap<String, String>();
				if (! orderService.findOrderById(order.getId()).isEmpty()) {
                    deleteOrder(order.getId());
				}
			} else {
				failureList.add(validationMessages(failures));
				failed = true;
			}
		}
		if (failed) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return failureList;
		} else {
			List<Map<String, Object>> responseList = new LinkedList<Map<String, Object>>();
			for (Order order: orders) {
				orderService.addOrder(order);
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("orgId", "00DR00000008bbz"); //order.getOrgId());
                map.put("id", order.getId());
				map.put("order_number", order.getOrderId());
                map.put("status", order.getStatus());
				responseList.add(map);
			}
			return responseList;
		}
	}

    @RequestMapping(value="{id}",method=RequestMethod.PUT)
    public @ResponseBody Order updateOrder(@PathVariable String id, @RequestBody Order order) {
        Order orderToUpdate = orderService.findOrder(id);
        if (orderToUpdate == null) {
            throw new ResourceNotFoundException(id);
        }
        if (order.getStatus() != null){
            orderToUpdate.setStatus(order.getStatus());
            orderToUpdate.setOrderId(order.getOrderId());
            orderToUpdate.setTotal(order.getTotal());
            orderService.updateOrder(orderToUpdate);
        }
        return orderToUpdate;
    }

	@RequestMapping(method=RequestMethod.GET)
	public @ResponseBody List<Order> getOrders(@RequestParam String orgId) {
        List<Order> lo = orderService.listOrders(orgId);

        // Need to clone the array list into an object that
        // is friendly to deserialization.
        List<Order> lo2 = new ArrayList<Order>();
        for (Order o : lo) {
            lo2.add(o.toJsonFriendly());
        }
        return lo2;
	}

	@RequestMapping(value="{id}", method=RequestMethod.GET)
	public @ResponseBody Order getOrder(@PathVariable String id) {
		Order order = orderService.findOrder(id);
		if (order == null) {
			throw new ResourceNotFoundException(id);
		}
		return order.toJsonFriendly();
	}

	@RequestMapping(value="{id}", method=RequestMethod.DELETE)
	@ResponseStatus(HttpStatus.OK)
	public void deleteOrder(@PathVariable String id) {
		orderService.removeOrder(id);
	}

	// internal helper
	private Map<String, String> validationMessages(Set<ConstraintViolation<Order>> failureSet) {
		Map<String, String> failureMessageMap = new HashMap<String, String>();
		for (ConstraintViolation<Order> failure : failureSet) {
			failureMessageMap.put(failure.getPropertyPath().toString(), failure.getMessage());
		}
		return failureMessageMap;
	}
}
