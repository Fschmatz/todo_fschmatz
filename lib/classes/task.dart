class Task{
  int id;
  String title;
  String note;
  int state; /*0 - todo, 1 - doing, 2 - done*/
  int idTodo;

  Task(this.id, this.title, this.note, this.state, this.idTodo);

  @override
  String toString() {
    return 'Task{id: $id, name: $title, note: $note, state:$state}';
  }
}