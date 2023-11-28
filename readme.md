Chat-Space
==========

A simple, flexible, and efficient one-on-one chat application built with OCaml.

Features
--------

* Dual mode: Can operate as a server or client
* Concurrent operations using `lwt` library
* Flexible message protocol for generic message exchange
* Console-based user interface for easy testing and messaging
* Error handling for robustness
* Roundtrip time measurement for communication latency insights

Development Progress
-------------------

1. Init (v0.1): Set up project foundation and chose key libraries
2. Server-Client Dynamics (v0.2): Implemented functional server and client with seamless message sending and receiving
3. Adaptable Message Handling (v0.3): Introduced flexible message protocol for generic message exchange
4. User Interface Enhancement (v0.4): Adopted console-based UI for simplicity and efficiency
5. Strengthening Robustness (v0.5): Addressed potential communication issues with error handling mechanisms
6. Introducing Latency Insights (v1.0): Integrated feature to measure roundtrip time for communication latency insights

## Usage

Follow these steps to build and run the Chat Space application:

1. **Build the Project:**
   ```bash
   $ dune build
    ```
2. **Help Command**:

    To view usage information, run:
    ```bash
    $ dune exec -- ./main.exe --0help
    ```

2. **Run the Server**:

    Choose a port number (e.g., 9999) to start the server.

    ```bash
    $ dune exec ./bin/main.exe 1 9999
    ```
3. **Run the Client**:

    Choose the same port number that the server is running on to start
    ```bash 
    $ dune exec ./bin/main.exe 2 9999
    ```
4. **Message Exchange**:

    Once the client is connected to the server, you can start exchanging messages between the server and client.

Note: Make sure to use the same port number for both.

