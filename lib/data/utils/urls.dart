class Urls {
  static const String baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String register = '$baseUrl/registration';
  static const String updateProfile = '$baseUrl/profileUpdate';
  static String verifyEmail(String email) =>
      '$baseUrl/RecoverVerifyEmail/$email';
  static String verifyOTP(String email, String otp) =>
      '$baseUrl/RecoverVerifyOTP/$email/$otp';
  static const String login = '$baseUrl/login';
  static const String resetPassword = '$baseUrl/RecoverResetPass';
  static const String addNewTask = '$baseUrl/createTask';
  static const String taskCountByStatus = '$baseUrl/taskStatusCount';
  static String taskListByStatus(String status) =>
      '$baseUrl/listTaskByStatus/$status';
  static String updateTaskStatus(String taskId, String status) =>
      '$baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTask(String id) => '$baseUrl/deleteTask/$id';
}
