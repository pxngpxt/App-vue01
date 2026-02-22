<template>
    <div class="container my-5">
      <!-- ✅ Loading -->
      <div v-if="loading" class="text-center my-5">
        <div class="spinner-border text-primary"></div>
        <p class="mt-3">กำลังโหลดข้อมูล...</p>
      </div>
      <!-- ✅ Error -->
      <div v-else-if="error" class="alert alert-danger text-center">
        {{ error }}
      </div>
      <!-- ✅ Detail -->
      <div v-else-if="product" class="row">
        <!-- ✅ รูปสินค้า -->
        <div class="col-md-5 text-center">
          <img
            :src="'http://localhost/app-vue01/php_api/uploads/' + product.image"
            class="img-fluid rounded shadow-sm"
          />
        </div>
        <!-- ✅ รายละเอียด -->
        <div class="col-md-7">
          <h2 class="fw-bold">{{ product.product_name }}</h2>
          <h4 class="text-primary my-3">{{ product.price }} บาท</h4>
          <p class="text-muted">{{ product.description }}</p>
          <!-- ✅ ปุ่ม -->
          <div class="mt-4">
            <button class="btn btn-primary btn-lg me-3">เพิ่มลงตะกร้า</button>
            <router-link to="/" class="btn btn-outline-secondary btn-lg">กลับ</router-link>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from "vue"
  import { useRoute } from "vue-router"
  
  const route = useRoute()
  const product = ref(null)
  const loading = ref(true)   // ✅ เพิ่ม
  const error = ref(null)     // ✅ เพิ่ม
  
  const fetchProduct = async () => {
    try {
      const id = route.params.id || route.query.id
      const response = await fetch(
        `http://localhost/app-vue01/php_api/show_product_detail.php?id=${id}`
      )
      const result = await response.json()
      console.log("API RESULT:", result)
  
      if (result.success) {
        product.value = result.data
      } else {
        error.value = result.message || "ไม่พบสินค้า"  // ✅ เซ็ต error
      }
    } catch (err) {
      error.value = "โหลดข้อมูลไม่ได้"                // ✅ เซ็ต error
      console.error("ERROR:", err)
    } finally {
      loading.value = false                              // ✅ ปิด loading
    }
  }
  
  onMounted(() => {
    fetchProduct()
  })
  </script>