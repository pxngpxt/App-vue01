import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/Customer',
    name: 'Customer',
    component: () => import( '../views/Customer_crud.vue')
  },
  {
    path: '/Contact',
    name: 'Contact',
    component: () => import( '../views/Contact.vue')
  },
  {
    path: '/type',
    name: 'type',
    component: () => import( '../views/type_crud.vue')
  }
  ,
  {
    path: '/employee',
    name: 'employee',
    component: () => import( '../views/employee_crud.vue')
  },
  {
    path: '/add_customer',
    name: 'add_customer',
    component: () => import( '../views/add_customer.vue')
  }
  ,
  {
    path: '/add_employee',
    name: 'add_employee',
    component: () => import( '../views/add_employee.vue')
  },
  {
    path: '/product',
    name: 'product',
    component: () => import( '../views/Product.vue')
  },
  {
    path: '/show_product',
    name: 'show_product',
    component: () => import( '../views/show_product.vue')
  },
  {
    path: '/sh_product',
    name: 'sh_product',
    component: () => import( '../views/sh_product.vue')
  },
  {
    path: '/student',
    name: 'student',
    component: () => import( '../views/student.vue')
  },
  {
    path: '/product_crud',
    name: 'product_crud',
    component: () => import( '../views/product_edit.vue')
  },
  {
    path: '/employee_crud',
    name: 'employee_crud',
    component: () => import( '../views/employee_edit.vue')
  }


]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
