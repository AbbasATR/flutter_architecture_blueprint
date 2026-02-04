String dateFormating(DateTime date) {
  // Format the date to a string in the format "dd/MM/yyyy"
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}
