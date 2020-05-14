package com.gquartet.GroupProject.services;

import com.gquartet.GroupProject.dtos.OrderDetailsDTO;
import com.gquartet.GroupProject.models.CustomerOrder;
import com.gquartet.GroupProject.models.OrderDetails;
import com.gquartet.GroupProject.models.Payment;
import com.gquartet.GroupProject.models.Product;
import com.gquartet.GroupProject.models.ShippingInformation;
import com.gquartet.GroupProject.repos.OrderDetailsRepository;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrderDetailsServiceImpl implements OrderDetailsService {

    @Autowired
    OrderDetailsRepository repo;

    @Override
    public void saveOrderDetails(OrderDetails orderDetails) {
    //public void saveOrderDetails(CustomerOrder customerOrder, Product pr, Payment payment, ShippingInformation shippingInformation) {
             
//        orderDetails.setOrderDetailsId(null);
//            orderDetails.setOrderNumber(customerOrder);
//            orderDetails.setProductId(pr);
//            orderDetails.setPaymentId(payment);
//            orderDetails.setShippingInformationId(shippingInformation);
        repo.save(orderDetails);
    }

    @Override
    public List<OrderDetails> getOrderDetails(CustomerOrder id) {
        return repo.findByOrderNumber(id);
    }
//    @Override
//    public List<OrderDetailsDTO> getOrderDetails(CustomerOrder id) {
//        return repo.findByOrderNumber(id);
//    }

    @Override
    public OrderDetails getOrderDetailsTakeId(Integer id) {
        return repo.getOne(id);

    }

}
