import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.clear, lineWidth: 1)
            )
    }
}

struct Task: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let date: Date
    var isCompleted: Bool = false // Add completed status
}

struct ContentView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var tasks: [Task] = []
    @State private var hoveredTaskId: UUID?

    var body: some View {
        VStack(spacing: 10) {
            Text("Tasks")
                .font(.title)

            TextField("Task Name", text: $name)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(.horizontal)

            TextField("Description", text: $description)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(.horizontal)

            DatePicker("Due Date:", selection: $date, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.horizontal)

            Button(action: addTask) {
                Text("Add Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 5) {
                    ForEach(tasks) { task in
                        taskRow(for: task)
                    }
                }
                .padding(.top)
            }
            .frame(maxHeight: 300) // Set a max height for the ScrollView
            
            Spacer()
        }
        .padding()
    }
    
    private func addTask() {
        let newTask = Task(name: name, description: description, date: date)
        tasks.append(newTask)
        name = ""
        description = ""
        date = Date() // Reset to current date
    }
    
    private func taskRow(for task: Task) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
                    .strikethrough(task.isCompleted) // Add strikethrough if completed
                Text(task.description)
                    .font(.subheadline)
                Text("\(task.date, formatter: dateFormatter)")
                    .font(.footnote)
            }
            Spacer()
            if hoveredTaskId == task.id {
                HStack {
                    Button(action: {
                        toggleCompletion(for: task)
                    }) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .font(.title)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        deleteTask(task)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(8)
        .background(Color.clear)
        .onHover { hovering in
            hoveredTaskId = hovering ? task.id : nil
        }
    }

    private func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle() // Toggle the completed status
        }
    }
    
    private func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
}

