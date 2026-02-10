<template>
  <div class="container mt-4">
    <h2 class="mb-3">รายชื่อนักเรียน</h2>
    
    <div class="mb-3">
      <button class="btn btn-primary" @click="openAddModal">
        <i class="bi bi-plus-circle"></i> เพิ่มนักเรียน
      </button>
    </div>

    <table class="table table-bordered table-striped">
      <thead class="table-primary">
        <tr>
          <th>รหัสนักเรียน</th>
          <th>ชื่อ</th>
          <th>นามสกุล</th>
          <th>เบอร์โทร</th>
          <th>อีเมล</th>
          <th>จัดการ</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="student in students" :key="student.student_id">
          <td>{{ student.student_id }}</td>
          <td>{{ student.first_name }}</td>
          <td>{{ student.last_name }}</td>
          <td>{{ student.phone }}</td>
          <td>{{ student.email }}</td>
          <td>
            <button class="btn btn-warning btn-sm" @click="openEditModal(student)">
              <i class="bi bi-pencil"></i> แก้ไข
            </button>
            
            <button class="btn btn-danger btn-sm ms-1" @click="deleteStudent(student.student_id)">
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

    <!-- Modal ใช้ทั้งเพิ่ม/แก้ไข -->
    <div class="modal fade" id="studentModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ isEditMode ? "แก้ไขข้อมูลนักเรียน" : "เพิ่มนักเรียนใหม่" }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="saveStudent">
              <div class="mb-3">
                <label class="form-label">ชื่อ <span class="text-danger">*</span></label>
                <input 
                  v-model="editStudent.first_name" 
                  type="text" 
                  class="form-control" 
                  placeholder="กรอกชื่อ"
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label">นามสกุล <span class="text-danger">*</span></label>
                <input 
                  v-model="editStudent.last_name" 
                  type="text" 
                  class="form-control" 
                  placeholder="กรอกนามสกุล"
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label">เบอร์โทร <span class="text-danger">*</span></label>
                <input 
                  v-model="editStudent.phone" 
                  type="tel" 
                  class="form-control" 
                  placeholder="เช่น 0812345678"
                  pattern="[0-9]{10}"
                  maxlength="10"
                  required
                >
                <small class="text-muted">กรุณากรอกเบอร์โทร 10 หลัก</small>
              </div>
              <div class="mb-3">
                <label class="form-label">อีเมล <span class="text-danger">*</span></label>
                <input 
                  v-model="editStudent.email" 
                  type="email" 
                  class="form-control" 
                  placeholder="เช่น example@email.com"
                  required
                >
              </div>
              <div class="d-flex gap-2">
                <button type="submit" class="btn btn-success">
                  <i class="bi bi-check-circle"></i>
                  {{ isEditMode ? "บันทึกการแก้ไข" : "เพิ่มนักเรียน" }}
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
  name: "StudentList",
  setup() {
    const students = ref([]);
    const loading = ref(true);
    const error = ref(null);
    const editStudent = ref({
      first_name: "",
      last_name: "",
      phone: "",
      email: ""
    });
    const isEditMode = ref(false);
    let studentModal = null;

    // ✅ ฟังก์ชันดึงข้อมูลนักเรียน
    const fetchStudents = async () => {
      try {
        loading.value = true;
        const response = await fetch("http://localhost/App-vue01/php_api/student.php");
        const result = await response.json();

        if (result.success) {
          students.value = result.data;
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
      fetchStudents();
      const modalEl = document.getElementById("studentModal");
      if (modalEl) {
        studentModal = new window.bootstrap.Modal(modalEl);
      }
    });

    // ✅ เปิด Modal เพิ่มนักเรียนใหม่
    const openAddModal = () => {
      isEditMode.value = false;
      editStudent.value = {
        first_name: "",
        last_name: "",
        phone: "",
        email: ""
      };
      if (studentModal) {
        studentModal.show();
      }
    };

    // ✅ เปิด Modal แก้ไขนักเรียน
    const openEditModal = (student) => {
      isEditMode.value = true;
      editStudent.value = { 
        student_id: student.student_id,
        first_name: student.first_name,
        last_name: student.last_name,
        phone: student.phone,
        email: student.email
      };
      if (studentModal) {
        studentModal.show();
      }
    };

    // ✅ บันทึกข้อมูล (เพิ่ม/แก้ไข)
    const saveStudent = async () => {
      const url = "http://localhost/App-vue01/php_api/student.php";
      const method = isEditMode.value ? "PUT" : "POST";

      try {
        const response = await fetch(url, {
          method,
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(editStudent.value)
        });

        const result = await response.json();

        if (result.success) {
          alert(result.message);
          fetchStudents(); // โหลดข้อมูลใหม่
          if (studentModal) {
            studentModal.hide();
          }
        } else {
          alert("เกิดข้อผิดพลาด: " + result.message);
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    // ✅ ลบนักเรียน
    const deleteStudent = async (id) => {
      if (!confirm("คุณต้องการลบข้อมูลนักเรียนนี้ใช่หรือไม่?")) return;
      
      try {
        const response = await fetch("http://localhost/App-vue01/php_api/student.php", {
          method: "DELETE",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ student_id: id })
        });
        
        const result = await response.json();
        
        if (result.success) {
          students.value = students.value.filter(s => s.student_id !== id);
          alert(result.message);
        } else {
          alert("เกิดข้อผิดพลาด: " + result.message);
        }
      } catch (err) {
        alert("เกิดข้อผิดพลาด: " + err.message);
      }
    };

    return {
      students,
      loading,
      error,
      editStudent,
      isEditMode,
      openAddModal,
      openEditModal,
      saveStudent,
      deleteStudent
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