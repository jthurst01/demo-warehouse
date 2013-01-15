package com.force.example.fulfillment.order.service;

import com.force.example.fulfillment.order.model.Order;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaQuery;
import javax.swing.plaf.basic.BasicInternalFrameTitlePane;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OrderServiceImpl implements OrderService {

    @PersistenceContext
    EntityManager em;
        
    @Transactional
	public void addOrder(Order order) {
        em.persist(order);
    }

//    @Transactional
	public List<Order> listOrders() {
		CriteriaQuery<Order> c = em.getCriteriaBuilder().createQuery(Order.class);
        c.from(Order.class);
        try {
            return em.createQuery(c).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

//    @Transactional
	public Order findOrder(Integer orderId) {
		return em.find(Order.class, orderId);
	}
	
    @Transactional
	public void removeOrder(Integer orderId) {
		Order order = em.find(Order.class, orderId);
		if (null != order) {
			em.remove(order);
		}
	}

	public List<Order> findOrderById(String id) {
		return em.createQuery("SELECT o FROM Order o WHERE o.id = :id", Order.class)
		    .setParameter("id", id)
		    .getResultList();
	}
}
