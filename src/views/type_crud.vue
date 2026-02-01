<template>
  <div class="container mt-4">
    <h2 class="mb-3">จัดการประเภทสินค้า</h2>
    
    <div class="mb-3">
      <button class="btn btn-primary" @click="openAddModal">
        <i class="bi bi-plus-circle"></i> เพิ่มประเภทสินค้า
      </button>
    </div>

    <table class="table table-bordered table-striped">
      <thead class="table-primary">
        <tr>
          <th style="width: 20%;">รหัส</th>
          <th style="width: 50%;">ชื่อประเภทสินค้า</th>
          <th style="width: 30%;">จัดการ</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="type in types" :key="type.type_id">
          <td>{{ type.type_id }}</td>
          <td>{{ type.type_name }}</td>
          <td>
            <button class="btn btn-warning btn-sm" @click="openEditModal(type)">
              <i class="bi bi-pencil"></i> แก้ไข
            </button>
            
            <button class="btn btn-danger btn-sm ms-2" @click="deleteType(type.type_id)">
              <i class="bi bi-trash"></i> ลบ
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-if="loading" class="text-center">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">กำลังโหลด...</span>
      </div>
    </div>
    
    <div v-if="error" class="alert alert-danger">{{ error }}</div>

    <!-- Modal สำหรับเพิ่ม/แก้ไข -->
    <div class="modal fade" id="typeModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              {{ isEditMode ? "แก้ไขประเภทสินค้า" : "เพิ่มประเภทสินค้าใหม่" }}
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="saveType">
              <div class="mb-3">
                <label class="form-label">ชื่อประเภทสินค้า <span class="text-danger">*</span></label>
                <input 
                  v-model="editType.type_name" 
                  type="text" 
                  class="form-control" 
                  placeholder="เช่น อิเล็กทรอนิกส์, เครื่องใช้ไฟฟ้า, อาหาร"
                  required
                >
              </div>
              <div class="d-flex gap-2">
                <button type="submit" class="btn btn-success">
                  <i class="bi bi-check-circle"></i>
                  {{ isEditMode ? "บันทึกการแก้ไข" : "เพิ่มประเภทสินค้า" }}
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                  ยกเลิก
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
  name: "TypeList",
  setup() {
    const types = ref([]);
    const loading = ref(true);
    const error = ref(null);
    const editType = ref({
      type_name: ""
    });
    const isEditMode = ref(false);
    let typeModal = null;

    // ✅ ฟังก์ชันดึงข้อมูลประเภทสินค้า
    const fetchTypes = async () => {
      try {
        loading.value = true;
        const response = await fetch("http://localhost/App-vue01/php_api/type_crud.php");
        const result = await response.json();

        if (result.success) {
          types.value = result.data;
          error.value = null;
        } else {
          error.value = result.message;
        }
      } catch (err) {
        error.value = "เกิดข้อผิดพลาด: " + err.message;
      } finally {
        loading.value = false;
      }
    };

    // ✅ เริ่มต้นเมื่อ Component โหลดเสร็จ
    onMounted(() => {
      fetchTypes();
      const modalEl = document.getElementById("typeModal");
      if (modalEl) {
        typeModal = new window.bootstrap.Modal(modalEl);
      }
    });

    // ✅ เปิด Modal เพิ่มประเภทสินค้าใหม่
    const openAddModal = () => {
      isEditMode.value = false;
      editType.value = {
        type_name: ""
      };
      if (typeModal) {
        typeModal.show();
      }
    };

    // ✅ เปิด Modal แก้ไขประเภทสินค้า
    const openEditModal = (type) => {
      isEditMode.value = true;
      editType.value = { 
        type_id: type.type_id,
        type_name: type.type_name
      };
      if (typeModal) {
        typeModal.show();
      }
    };

    // ✅ บันทึกข้อมูล (เพิ่ม/แก้ไข)
    const saveType = async () => {
      const url = "http://localhost/App-vue01/php_api/type_crud.php";
      const method = isEditMode.value ? "PUT" : "POST";

      try {
        const response = await fetch(url, {
          method,
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(editType.value)
        });

        const result = await response.json();

        if (result.success) {
          alert(result.message);
          fetchTypes(); // โหลดข้อมูลใหม่
          if (typeModal) {
            typeModal.hide();
          }
        } else {
          alert("เกิดข้อผิดพลาด: " + result.message);
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    // ✅ ลบประเภทสินค้า
    const deleteType = async (id) => {
      if (!confirm("คุณต้องการลบประเภทสินค้านี้ใช่หรือไม่?")) return;
      
      try {
        const response = await fetch("http://localhost/App-vue01/php_api/type_crud.php", {
          method: "DELETE",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ type_id: id })
        });
        
        const result = await response.json();
        
        if (result.success) {
          types.value = types.value.filter(t => t.type_id !== id);
          alert(result.message);
        } else {
          alert("เกิดข้อผิดพลาด: " + result.message);
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    return {
      types,
      loading,
      error,
      editType,
      isEditMode,
      openAddModal,
      openEditModal,
      saveType,
      deleteType
    };
  }
};
</script>

<style scoped>
.table th {
  background-color: #0d6efd;
  color: white;
  text-align: center;
  vertical-align: middle;
}

.table td {
  vertical-align: middle;
}

.btn-sm {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}
</style>