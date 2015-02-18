class Student
  attr_reader :id
  attr_accessor :name, :age, :spirit_animal, :squad_id

  def initialize params, existing=false
    @name = params["name"]
    @age = params["age"]
    @spirit_animal = params["spirit_animal"]
    @squad_id = params["squad_id"]
    @existing = existing
  end

  def existing?
    @existing
  end

  def self.all
    @conn.exec("SELECT * FROM students")
  end

# should return individual student info by id
  def self.find id
    new @conn.exec('SELECT * FROM students WHERE student_id = $1 AND squad_id = $2', [ id, squad_id ] )
  end
  
  def Student 
    Student.conn.exec('SELECT * FROM students WHERE id = $1 AND squad_id = $2', [ id, squad_id ] )
  end


  def save 
    if existing?
      Student.conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3 WHERE id = $4', [name, age,  spirit_animal, id ] ) 
    else
      Student.conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) values ($1,$2,$3,$4)', [name, age, spirit_animal, squad_id])
    end
  end
  
  def self.create params
    new(params).save
  end
  
  def destroy
    Student.conn.exec('DELETE FROM students WHERE student_id = ($1)', [ student_id ] )
  end
end


