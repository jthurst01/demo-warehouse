package com.force.example.fulfillment.order.model;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.springframework.core.style.ToStringCreator;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name="ORDERS")
@JsonIgnoreProperties(ignoreUnknown=true)
public class Order {

    @Id
	@NotNull
//    @Column(name = "ORDER_ID")
	@Size(min = 15, max = 18)
	private String id;

    @Column
    private String orderId;

    @Column
    private float total;

    @Column
    private String status;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch= FetchType.EAGER)
    private Set<LineItem> lineItems;

    public String getOrderId() {
		return orderId;
	}

	void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
    }

    public Set<LineItem> getLineItems() {
        return lineItems;
    }

    public void setLineItems(Set<LineItem> lineItems) {
        Set<LineItem> lis = new HashSet<LineItem>();
        for (LineItem li : lineItems) {
            LineItem nli = new LineItem();
            nli.setId(li.getId());
            nli.setItem(li.getItem());
            nli.setLineItemId(li.getLineItemId());
            nli.setQuantity(li.getQuantity());
            nli.setTotal(li.getTotal());
            nli.setUnitPrice(li.getUnitPrice());

//            Order o = new Order();
//            o.setOrderId(this.getOrderId());
//            o.setId(this.getId());
//            nli.setOrder(o);
            nli.setOrder(this);
            lis.add(nli);
            System.out.println("------------HERE-----------" + nli.toJsonFriendly());
        }
        this.lineItems = lis;
    }

    public String toString() {
		return new ToStringCreator(this).append("orderId", orderId).append("id", id)
				.append("status", status).toString();
	}

    public Order toJsonFriendly() {
        Order o = new Order();
        o.id = this.id;
        o.orderId = this.orderId;
        o.total = this.total;
        o.status = this.status;
        o.lineItems = new HashSet<LineItem>();
        for (LineItem li : lineItems) {
            o.lineItems.add(li.toJsonFriendly());
        }
        return o;
    }

    @Transient
    public int getLineItemCount(){
        return getLineItems().size();
    }

}
