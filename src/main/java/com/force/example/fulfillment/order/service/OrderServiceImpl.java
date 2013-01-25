package com.force.example.fulfillment.order.service;

import com.force.example.fulfillment.order.model.LineItem;
import com.force.example.fulfillment.order.model.Order;

import java.util.List;
import java.util.Set;

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

    @Transactional
    public void addLineItem(LineItem li) {
        em.persist(li);
    }

    @Transactional
    public void updateOrder(Order order){
        em.merge(order);
    }

    @Transactional
    public void updateLineItem(LineItem li){
        em.merge(li);
    }

	public List<Order> listOrders() {
		CriteriaQuery<Order> c = em.getCriteriaBuilder().createQuery(Order.class);
        c.from(Order.class);
        return em.createQuery(c).getResultList();
    }

	public Order findOrder(String id) {
		return em.find(Order.class, id);
	}

    public LineItem findLineItem(String id) {
        return em.find(LineItem.class, id);
    }

    @Transactional
	public void removeOrder(String id) {
		Order order = em.find(Order.class, id);
		if (null != order) {
			em.remove(order);
		}
	}

	public List<Order> findOrderById(String id) {
		return em.createQuery("SELECT o FROM Order o WHERE o.id = :id", Order.class)
		    .setParameter("id", id)
		    .getResultList();
	}

    public List<LineItem> findLineItemById(String id) {
        return em.createQuery("SELECT l FROM LineItem l WHERE l.id = :id", LineItem.class)
                .setParameter("id", id)
                .getResultList();
    }
}
