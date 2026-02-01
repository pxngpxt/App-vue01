<template>
  <div class="container mt-4">
    <h2 class="mb-3">รายชื่อพนักงาน</h2>
    
    <div class="mb-3">
      <button class="btn btn-primary" @click="openAddModal">
        Add <i class="bi bi-plus-circle"></i>
      </button>
    </div>

    <table class="table table-bordered table-striped">
      <thead class="table-primary">
        <tr>
          <th>ID</th>
          <th>ชื่อ-นามสกุล</th>
          <th>แผนก</th>
          <th>เงินเดือน</th>
          <!-- ✅ เพิ่มคอลัมน์ Active -->
          <th>สถานะ</th>
          <th>จัดการ</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="employee in employees" :key="employee.emp_id">
          <td>{{ employee.emp_id }}</td>
          <td>{{ employee.full_name }}</td>
          <td>{{ employee.department }}</td>
          <td>{{ Number(employee.salary).toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</td>
          <!-- ✅ แสดงสถานะ Active -->
          <td>
            <span v-if="employee.active == 1" class="badge bg-success">ปกติ</span>
            <span v-else class="badge bg-danger">ลาออก</span>
          </td>
          <td>
            <button class="btn btn-warning btn-sm" @click="openEditModal(employee)">
              แก้ไข
            </button>
            |
            <button class="btn btn-danger btn-sm" @click="deleteEmployee(employee.emp_id)">
              ลบ
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-if="loading" class="text-center"><p>กำลังโหลดข้อมูล...</p></div>
    <div v-if="error" class="alert alert-danger">{{ error }}</div>

    <!-- Modal ใช้ทั้งเพิ่ม/แก้ไข -->
    <div class="modal fade" id="editModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ isEditMode ? "แก้ไขข้อมูลพนักงาน" : "เพิ่มพนักงานใหม่" }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="saveEmployee">
              <div class="mb-3">
                <label class="form-label">ชื่อ-นามสกุล</label>
                <input v-model="editEmployee.full_name" type="text" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">แผนก</label>
                <input v-model="editEmployee.department" type="text" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">เงินเดือน</label>
                <input v-model="editEmployee.salary" type="number" step="0.01" class="form-control" required>
              </div>
              <!-- ✅ ไม่ต้องมี input สำหรับ active เพราะ backend จัดการให้แล้ว -->
              <button type="submit" class="btn btn-success">
                {{ isEditMode ? "บันทึกการแก้ไข" : "เพิ่มพนักงาน" }}
              </button>
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
  name: "EmployeeList",
  setup() {
    const employees = ref([]);
    const loading = ref(true);
    const error = ref(null);
    const editEmployee = ref({
      full_name: "",
      department: "",
      salary: ""
    });
    const isEditMode = ref(false);
    let editModal = null;

    // ✅ ฟังก์ชัน Fetch ข้อมูล
    const fetchEmployee = async () => {
      try {
        const response = await fetch("http://localhost/App-vue01/php_api/employee_crud.php");
        const result = await response.json();

        if (result.success) {
          employees.value = result.data;
        } else {
          error.value = result.message;
        }
      } catch (err) {
        error.value = err.message;
      } finally {
        loading.value = false;
      }
    };

    // ✅ เริ่มต้นเมื่อ Component โหลดเสร็จ
    onMounted(() => {
      fetchEmployee();
      const modalEl = document.getElementById("editModal");
      if (modalEl) {
        editModal = new window.bootstrap.Modal(modalEl);
      }
    });

    // ✅ เปิด Modal เพิ่มพนักงานใหม่
    const openAddModal = () => {
      isEditMode.value = false;
      editEmployee.value = {
        full_name: "",
        department: "",
        salary: ""
        // ✅ ไม่ต้องส่ง active เพราะ backend กำหนดเป็น 1 อัตโนมัติ
      };
      if (editModal) {
        editModal.show();
      }
    };

    // ✅ เปิด Modal แก้ไขพนักงาน
    const openEditModal = (employee) => {
      isEditMode.value = true;
      editEmployee.value = { 
        emp_id: employee.emp_id,
        full_name: employee.full_name,
        department: employee.department,
        salary: employee.salary
        // ✅ ไม่ต้องส่ง active เพราะ backend กำหนดเป็น 1 อัตโนมัติ
      };
      if (editModal) {
        editModal.show();
      }
    };

    // ✅ บันทึกข้อมูล (เพิ่ม/แก้ไข)
    const saveEmployee = async () => {
      const url = "http://localhost/App-vue01/php_api/employee_crud.php";
      const method = isEditMode.value ? "PUT" : "POST";

      try {
        const response = await fetch(url, {
          method,
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(editEmployee.value)
        });

        const result = await response.json();

        if (result.success) {
          alert(result.message);
          fetchEmployee();
          if (editModal) {
            editModal.hide();
          }
        } else {
          alert(result.message);
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    // ✅ ลบพนักงาน
    const deleteEmployee = async (id) => {
      if (!confirm("คุณต้องการลบข้อมูลนี้ใช่หรือไม่?")) return;
      
      try {
        const response = await fetch("http://localhost/App-vue01/php_api/employee_crud.php", {
          method: "DELETE",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ emp_id: id })
        });
        
        const result = await response.json();
        
        if (result.success) {
          employees.value = employees.value.filter(c => c.emp_id !== id);
          alert(result.message);
        } else {
          alert(result.message);
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    return {
      employees,
      loading,
      error,
      editEmployee,
      isEditMode,
      openAddModal,
      openEditModal,
      saveEmployee,
      deleteEmployee
    };
  }
};
</script>

<style scoped>
/* ✅ เพิ่ม style สำหรับ badge */
.badge {
  padding: 5px 10px;
  border-radius: 4px;
}
</style>