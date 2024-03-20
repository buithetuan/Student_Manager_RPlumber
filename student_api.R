# Load required libraries
library(plumber)
library(RSQLite)

# Establish connection to SQLite database
con <- dbConnect(SQLite(), "student_database.db")

# Define Plumber API
#* @apiTitle Student Management API

#* Get all students
#* @get /students
function() {
  query <- "SELECT * FROM students"
  result <- dbGetQuery(con, query)
  return(result)
}

#* Add a student
#* @param name The name of the student
#* @param age The age of the student
#* @param gpa The GPA of the student
#* @param email The email of the student
#* @param hometown The hometown of the student
#* @post /add_student
function(name, age, gpa, email, hometown) {
  query <- sprintf("INSERT INTO students (name, age, gpa, email, hometown) VALUES ('%s', %i, %f, '%s', '%s')", name, age, gpa, email, hometown)
  dbExecute(con, query)
  return("Student added successfully")
}

#* Update a student
#* @param id The id of the student to update
#* @param name The new name of the student
#* @param age The new age of the student
#* @param gpa The new GPA of the student
#* @param email The new email of the student
#* @param hometown The new hometown of the student
#* @put /update_student
function(id, name, age, gpa, email, hometown) {
  query <- sprintf("UPDATE students SET name='%s', age=%i, gpa=%f, email='%s', hometown='%s' WHERE id=%i", name, age, gpa, email, hometown, id)
  dbExecute(con, query)
  return("Student updated successfully")
}

#* Delete a student
#* @param id The id of the student to delete
#* @delete /delete_student
function(id) {
  query <- sprintf("DELETE FROM students WHERE id=%i", id)
  dbExecute(con, query)
  return("Student deleted successfully")
}

#' @filter cors
cors <- function(req, res) {
  
  res$setHeader("Access-Control-Allow-Origin", "*")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200 
    return(list())
  } else {
    plumber::forward()
  }
}
