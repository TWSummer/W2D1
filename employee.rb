class Employee
  attr_reader :salary
  def initialize(money)
    @salary = money
  end
  def bonus(multiplier)
    @salary*multiplier
  end
end

class Manager < Employee
  def initialize(money)
    @employees = []
    super(money)
  end

  def bonus(multiplier)
    return 0 if @employees.empty?
    sub_salaries = 0
    @employees.each do |employee|
      sub_salaries += employee.salary
      sub_salaries += employee.bonus(1) if employee.is_a?(Manager)
    end
    sub_salaries * multiplier
  end

  def add_employee(employee)
    @employees << employee
  end
end

if __FILE__ == $PROGRAM_NAME
  david = Employee.new(10000)
  shawna = Employee.new(12000)
  darren = Manager.new(78000)
  darren.add_employee(shawna)
  darren.add_employee(david)
  ned = Manager.new(1000000)
  ned.add_employee(darren)
  p david.bonus(3)
  p darren.bonus(4)
  p ned.bonus(5)
end
