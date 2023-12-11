# AppointmentAgenda

AppointmentAgenda is an assembly-based scheduling tool that enforces scheduling rules, prevents conflicts, and provides flexibility to edit and remove events, ensuring an efficient and organized event management experience.

## Functionalities

### Event Details
Each event in AppointmentAgenda consists of a name, date, start time, and end time. This comprehensive information allows users to clearly understand the event schedule.

### Conflict Resolution
To maintain an organized and conflict-free agenda, AppointmentAgenda uses an automatic conflict detection system. If any event conflicts with an existing one in terms of time, the new event cannot be registered. This feature ensures that events do not overlap or create scheduling conflicts.

### Event Modification
Users have the flexibility to modify and edit events in AppointmentAgenda. This feature is essential for making adjustments to event details, such as changing the event name, date, or time.

### Removing Events
Additionally, the calendar allows users to remove events. This feature ensures that outdated or canceled events can be easily removed from the schedule, maintaining an organized and accurate schedule.

## Getting Started

### Prerequisites

- [OpenJDK](https://openjdk.org/) or [Java](https://www.oracle.com/br/java/technologies/downloads/)
- [Mars](https://courses.missouristate.edu/KenVollmar/mars/download.htm)

### Installation

1. Clone the repository

    ```bash
    git clone https://github.com/lfelipediniz/AppointmentAgenda.git
    ```

2. Navigate to the project directory

    ```bash
    cd AppointmentAgenda
    ```

3. Run in terminal directly through, 
    ```bash
    java -jar Mars4_5.jar nc main.asm
    ```
note that your Mars file may have another name

### Usage

To run our code, open it in the **Mars** program. After opening it, press the F3 key on your keyboard. If everything goes well, press F5 and enjoy your agenda of appointments.



## Authors

| Names                       | USP Number |
| :---------------------------| ---------- |
| Luiz Felipe Diniz Costa     | 13782032   |
| Rafael Jun Morita           | 10845040   |

Project for the course ["Computer Organization and Architecture"](https://uspdigital.usp.br/jupiterweb/obterDisciplina?sgldis=SSC0902) at the Institute of Mathematics and Computer Science, University of Sao Paulo
