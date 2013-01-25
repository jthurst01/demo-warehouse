/*
 * Copyright, 1999-2012, salesforce.com
 * All Rights Reserved
 * Company Confidential
 */
package com.force.example.fulfillment.order.model;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;

import javax.persistence.*;
import javax.validation.constraints.Size;

@Entity
@Table(name="LINE_ITEM")
@JsonIgnoreProperties(ignoreUnknown=true)
public class LineItem {

    private String id;
    private String lineItemId;
    private Integer quantity;
    private float unitPrice;
    private float total;
    private String item;
    private Order order;

    @Id
    @Size(min = 15, max = 18)
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Column
    public String getLineItemId() {
        return lineItemId;
    }

    public void setLineItemId(String lineItemId) {
        this.lineItemId = lineItemId;
    }

    @Column
    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    @Column
    public float getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(float unitPrice) {
        this.unitPrice = unitPrice;
    }

    @Column
    public String getItem() {
        return item;
    }

    public void setItem(String item) {
        this.item = item;
    }

    @Column
    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
    }

    @ManyToOne @JoinColumn(name="ORDER_ID", nullable=false)
    @JsonIgnore
    public Order getOrder() {
        return order;
    }

    @JsonIgnore
    public void setOrder(Order order) {
        this.order = order;
    }

    public LineItem toJsonFriendly() {
        LineItem li = new LineItem();
        li.id = this.id;
        li.lineItemId = this.lineItemId;
        li.quantity = this.quantity;
        li.unitPrice = this.unitPrice;
        li.total = this.total;
        li.item = this.item;
        return li;
    }


}
