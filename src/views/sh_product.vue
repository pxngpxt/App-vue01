<template>
  <div class="container my-5">
    <!-- หัวข้อหลัก -->
    <h2 class="text-center mb-4">รายการสินค้า</h2>

    <!-- Loading -->
    <div v-if="loading" class="text-center my-5">
      <div class="spinner-border text-primary"></div>
      <p class="mt-3">กำลังโหลดข้อมูล...</p>
    </div>

    <!-- Error -->
    <div v-else-if="error" class="alert alert-danger text-center">
      {{ error }}
    </div>

    <!-- ใช้ Bootstrap แบ่ง row -->
    <div v-else class="row">
      <!-- วน loop แสดงสินค้าแต่ละตัว ด้วย v-for -->
      <div class="col-md-3" v-for="data in Alldata" :key="data.product_id">

        <!-- card แสดงข้อมูลสินค้า -->
        <div class="card shadow-sm mb-4">
          <!-- แสดงรูปสินค้า โดย path รูปมาจาก server -->
          <img
            :src="'http://localhost/App-vue01/php_api/uploads/' + data.image"
            width="70%"
            height="300"
            class="card-img-top"
            :alt="data.product_name"
          >

          <!-- เนื้อหาใน card -->
          <div class="card-body text-center">
            <h5 class="card-title">{{ data.product_name }}</h5>
            <p class="card-text">{{ data.price }} บาท</p>
            <!-- ✅ ปุ่มไปหน้า ProductDetail -->
            <router-link
              :to="'/ProductDetail/' + data.product_id"
              class="btn btn-primary"
            >
              ดูรายละเอียด
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
  name: "DataList",
  setup() {
    const Alldata = ref([]);
    const loading = ref(true);
    const error = ref(null);

    // ฟังก์ชันดึงข้อมูลจาก API
    const fetchData = async () => {
      try {
        const response = await fetch("http://localhost/App-vue01/php_api/api_product.php");
        if (!response.ok) {
          throw new Error("ไม่สามารถดึงข้อมูลได้");
        }
        const result = await response.json();
        Alldata.value = result.success ? result.data : [];
      } catch (err) {
        error.value = err.message;
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      fetchData();
    });

    return {
      Alldata,
      loading,
      error
    };
  }
};
</script>