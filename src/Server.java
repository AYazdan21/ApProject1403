import java.util.*;
import java.io.*;
import java.net.*;

class Server {
    public static void main(String[] args) throws IOException {
        System.out.println("Welcome to the Server!");
        ServerSocket serverSocket = new ServerSocket(8412);
        while (true) {
            System.out.println("Waiting for Client...");
            new ClientHandler(serverSocket.accept()).start();
        }
    }
}

class ClientHandler extends Thread {
    Socket socket;
    DataOutputStream dos;
    DataInputStream dis;
    //

    public ClientHandler(Socket socket) throws IOException {
        this.socket = socket;
        dos = new DataOutputStream(socket.getOutputStream());
        dis = new DataInputStream(socket.getInputStream());
        System.out.println("Connected to Server!");
    }

    public String listener() throws IOException {
        System.out.println("listener is activated!");
        StringBuilder sb = new StringBuilder();
        int index = dis.read();
        while (index != 0) {
            sb.append((char) index);
            index = dis.read();
        }
        System.out.println("listener -> command read successfully");
        return sb.toString();
    }

    //send the response to server
    public void writer(String write) throws IOException {
        dos.writeBytes(write);
        dos.flush();
        dos.close();
        dis.close();
        System.out.println(write);
        System.out.println("command finished and response sent to server");

    }

    @Override
    public void run() {
        super.run();
        String command;

        try {
            command = listener();
            System.out.println("Command received: { " + command + " }");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        String[] split = command.split("~");
        for (String s : split) {
            System.out.println(s);
        }

        switch (split[0]) {
            case "login": {
                //3 --> ID: correct & Password: correct --> login successful
                //2 --> ID: correct & Password: incorrect --> incorrect password
                //1 --> ID: incorrect & Password: correct --> incorrect ID
                //login~stuID~password --> format of message
                boolean logedIn = false;
                int responseOfDatabase = 0;

                responseOfDatabase = DB.studentLogIn(split[1], split[2]);

                if (responseOfDatabase == 3) {
                    logedIn = true;
                    System.out.println("status code is 200");
                    System.out.println("Successfully logged in!");
                    try {
                        writer("200");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                else if (responseOfDatabase == 2) {
                    logedIn = false;
                    System.out.println("status code is 401");
                    System.out.println("Password is incorrect");
                    try {
                        writer("401");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                else if (responseOfDatabase == 1) {
                    logedIn = false;
                    System.out.println("status code is 404");
                    System.out.println("Student Number is incorrect");
                    try {
                        writer("404");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;
            }

            case "signUp": {
                //2 --> signup successful
                //1 --> signup failed --> already exists
                //signUp~firstname~surname~stuID~password
                boolean signupCompleted = false;
                boolean checkStudentExists = false;

                checkStudentExists = DB.checkStudentInFile(split[3]);

                if (checkStudentExists) {
                    System.out.println("status code is 1");
                    System.out.println("signUp failed... Student already exists");
                    try {
                        writer("1");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                else {
                    DB.saveStudentToFile(split[3], split[4], "", split[1], split[2]);
                    System.out.println("status code is 2");
                    System.out.println("signUp successful");
                    try {
                        writer("2");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
