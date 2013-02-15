package com.force.example.fulfillment.order.service;

import com.force.example.fulfillment.order.model.LineItem;
import com.force.example.fulfillment.order.model.Order;

import java.util.List;
import java.util.Set;

public interface OrderService {
    public void addOrder(Order order);
    public List<Order> listOrders(String orgId);
    public Order findOrder(String orderId);
    public void removeOrder(String orderId);
	List<Order> findOrderById(String id);
	public void updateOrder(Order order);
}