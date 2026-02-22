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
    component: () => import('../views/Customer_crud.vue')
  },
  {
    path: '/Contact',
    name: 'Contact',
    component: () => import('../views/Contact.vue')
  },
  {
    path: '/type',
    name: 'type',
    component: () => import('../views/type_crud.vue')
  },
  {
    path: '/employee',
    name: 'employee',
    component: () => import('../views/employee_crud.vue')
  },
  {
    path: '/add_customer',
    name: 'add_customer',
    component: () => import('../views/add_customer.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/add_employee',
    name: 'add_employee',
    component: () => import('../views/add_employee.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/product',
    name: 'product',
    component: () => import('../views/Product.vue')
  },
  {
    path: '/show_product',
    name: 'show_product',
    component: () => import('../views/show_product.vue')
  },
  {
    path: '/sh_product',
    name: 'sh_product',
    component: () => import('../views/sh_product.vue')
  },
  {
    path: '/student',
    name: 'student',
    component: () => import('../views/student.vue')
  },
  {
    path: '/product_crud',
    name: 'product_crud',
    component: () => import('../views/product_edit.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/employee_crud',
    name: 'employee_crud',
    component: () => import('../views/employee_edit.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/Login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  // ✅ เพิ่ม ProductDetail route
  {
    path: '/ProductDetail/:id',
    name: 'ProductDetail',
    component: () => import('../views/ProductDetail.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

/* ✅ ROUTE GUARD */
router.beforeEach((to, from, next) => {

  const isLoggedIn = localStorage.getItem("adminLogin")

  // ถ้าหน้านั้นต้อง login แต่ยังไม่ login
  if (to.meta.requiresAuth && !isLoggedIn) {
    next('/Login')   // ✅ แก้เป็น /Login ให้ตรงกับ route ที่ตั้งไว้
  }
  // ถ้า login แล้วแต่พยายามเข้าหน้า login
  else if (to.path === '/Login' && isLoggedIn) {
    next('/')
  }
  else {
    next()
  }
})

export default router