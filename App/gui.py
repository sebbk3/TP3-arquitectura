import tkinter as tk
import tkinter.messagebox as messagebox
import os

from tkinter import filedialog
from uart import Uart
from compiler import compilar
import serial.tools.list_ports

COMMAND_1 = "Escribir programa"
COMMAND_2 = "Ejecucion continua"
COMMAND_3 = "Step by step"
COMMAND_4 = "Send step"

commands = {1: COMMAND_1,
            2: COMMAND_2,
            3: COMMAND_3,
            4: COMMAND_4
            }

mem_data_SIZE = 128  # 128 bytes of depth
REGISTER_BANK_SIZE = 128  # 32 * 4 bytes
PC_SIZE = 4  # 4 bytes
INS_MEM_SIZE = 256  # lineas
mem_data_FILE = 'mem_data.txt'
REGISTER_BANK_FILE = 'register_bank.txt'
PC_FILE = 'program_counter.txt'

commands_files = {4: [REGISTER_BANK_SIZE],
                  5: [mem_data_SIZE],
                  6: [PC_SIZE]}

class GUI:

    def __init__(self, uart_port='loop://', baudrate=19200):

        self.cycle_count = 1

        self.next_action = {1: self.send_program,
                            # 4: self.receive_file,  # Comentar esta línea
                            5: self.receive_file,
                            6: self.receive_file, }

        self.instruction_size = 0
        self.compiled = []
        self.ventana = tk.Tk()  # Main menu
        self.ventana.title("MIPS")
        self.ventana.geometry("600x400")  # Ajustar tamaño para mostrar todo

        # Configuración de colores para el tema más claro
        self.ventana.configure(bg='#555555')  # Fondo gris más claro
        self.fg_color = 'white'  # Texto blanco
        self.bg_color = '#555555'  # Fondo gris claro para widgets
        self.button_color = '#FFFFFF'  # Botón blanco
        self.button_fg_color = '#000000'  # Texto del botón negro
        self.button_hover_color = '#777777'  # Color al pasar el ratón por el botón
        self.change_highlight_color = '#FF9999'  # Rojo más opaco para los cambios

        self.selected_port = None
        self.selected_baudrate = baudrate
        self.uart = None
        self.file_ventana = None  # File ventana
        self.ex_ventana = None  # Execution ventana
        self.debug_ventana = None  # Debug ventana
        self.maximum_steps = None
        self.last_command = 0
        self.sent_step = 0
        self.selected_file = None  # Asegurar que el archivo seleccionado esté inicializado

        self.previous_bank_register = []  # Almacenar el estado anterior del registro de banco
        self.previous_memory = []  # Almacenar el estado anterior de la memoria

        # Obtener lista de puertos COM disponibles
        ports = [port.device for port in serial.tools.list_ports.comports()]
        if not ports:
            ports = ["COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7"]

        self.port_var = tk.StringVar()
        if ports:
            self.port_var.set(ports[0])

        self.baudrate_var = tk.StringVar()
        self.baudrate_var.set(baudrate)

        self.create_main_widgets()

        self.ventana.mainloop()

    def create_main_widgets(self):
        """Crea los widgets de la ventana principal."""

        # Limpiar ventana principal antes de crear widgets
        for widget in self.ventana.winfo_children():
            widget.destroy()

        # Frame principal para la organización de widgets
        main_frame = tk.Frame(self.ventana, bg=self.bg_color)
        main_frame.pack(pady=10)

        # Menú desplegable para seleccionar el puerto COM
        port_menu = tk.OptionMenu(main_frame, self.port_var, *self.port_var.get())
        port_menu.config(bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))  # Botón más grande
        port_menu.grid(row=0, column=0, padx=5, pady=5, sticky="e")

        # Botón para seleccionar el puerto
        select_button = tk.Button(main_frame, text="Seleccionar Puerto", command=self.on_select,
                                  bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))
        select_button.grid(row=0, column=1, padx=5, pady=5, sticky="w")

        # Selección de archivo
        select_file_button = tk.Button(main_frame, text="Seleccionar archivo", command=self.select_file, width=15,
                                       bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))
        select_file_button.grid(row=1, column=0, padx=5, pady=5, sticky="e")

        # Baudrate selección
        baudrate_label = tk.Label(main_frame, text="Baudrate:", bg=self.bg_color, fg=self.fg_color, font=("Arial", 12))
        baudrate_label.grid(row=2, column=0, padx=5, pady=5, sticky="e")

        baudrate_menu = tk.OptionMenu(main_frame, self.baudrate_var, 9600, 19200, 38400, 57600, 115200)
        baudrate_menu.config(bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))  # Botón más grande
        baudrate_menu.grid(row=2, column=1, padx=5, pady=5, sticky="w")

        # Frame para el área de texto
        text_frame = tk.Frame(self.ventana, bg=self.bg_color)
        text_frame.pack(padx=10, pady=10)

        # Contador de líneas
        self.line_numbers = tk.Text(text_frame, wrap=tk.NONE, width=4, height=10, state=tk.DISABLED, bg=self.bg_color, fg=self.fg_color)
        self.line_numbers.grid(row=0, column=0, padx=(0, 5), sticky="ns")

        # Área de texto para mostrar el contenido del archivo seleccionado
        self.text_widget = tk.Text(text_frame, wrap=tk.NONE, width=50, height=10, bg=self.bg_color, fg=self.fg_color)
        self.text_widget.grid(row=0, column=1, sticky="nsew")
        self.text_widget.configure(state='disabled')

        # Scrollbar para el área de texto
        scrollbar = tk.Scrollbar(text_frame, command=self.text_widget.yview)
        scrollbar.grid(row=0, column=2, sticky='ns')
        self.text_widget.config(yscrollcommand=scrollbar.set)

        # Botón Iniciar (inicialmente oculto)
        self.start_button = tk.Button(self.ventana, text="Iniciar", command=self.iniciar,
                                      bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))
        self.start_button.pack(pady=10)
        self.start_button.pack_forget()  # Ocultar el botón inicialmente

        # Aplicar efectos de hover a los botones
        self.apply_hover_effects(select_button)
        self.apply_hover_effects(select_file_button)
        self.apply_hover_effects(self.start_button)
        self.apply_hover_effects(port_menu)
        self.apply_hover_effects(baudrate_menu)

    def apply_hover_effects(self, widget):
        """Aplica efectos de hover para que los botones cambien de color al pasar el ratón por encima."""
        def on_enter(e):
            widget['background'] = self.button_hover_color

        def on_leave(e):
            widget['background'] = self.button_color

        widget.bind("<Enter>", on_enter)
        widget.bind("<Leave>", on_leave)

    def on_select(self):
        self.selected_port = self.port_var.get()
        self.selected_baudrate = int(self.baudrate_var.get())
        print("Selected port:", self.selected_port)
        print("Selected baudrate:", self.selected_baudrate)

        try:
            self.uart = Uart(self.selected_port, self.selected_baudrate)
            if self.uart:
                message = f"UART Creada en puerto {self.selected_port} a {self.selected_baudrate} baudios"
                messagebox.showinfo("UART Creada", message)
            else:
                messagebox.showerror("Error", "No se pudo crear la UART.")
        except Exception as e:
            messagebox.showerror("Error", f"Error al crear la UART: {str(e)}")

    def select_file(self):
        initial_directory = os.getcwd()
        file_path = filedialog.askopenfilename(
            filetypes=[("Archivos de texto", "*.txt")],
            initialdir=initial_directory
        )
        self.selected_file = file_path

        # Actualizar contenido del archivo seleccionado en la primera ventana
        if self.selected_file:
            self.text_widget.configure(state='normal')

            with open(self.selected_file, 'r') as file:
                file_content = file.read()
                self.text_widget.delete(1.0, tk.END)
                self.text_widget.insert(tk.END, file_content)
                self.update_line_numbers()

            self.text_widget.configure(state='disabled')
            self.start_button.pack()  # Mostrar el botón "Iniciar" después de seleccionar un archivo

    def iniciar(self):
        """Función para compilar y enviar el programa."""
        self.compile_and_send_program()

    def compile_and_send_program(self):
        """Compila el archivo seleccionado y envía el programa."""
        if self.selected_file:
            try:
                self.compiled = compilar(self.selected_file)
                print("Compilación exitosa.")
                self.send_program()  # Enviar programa después de compilar
            except Exception as e:
                messagebox.showerror("Error", f"Error al compilar: {str(e)}")
        else:
            messagebox.showwarning("Advertencia", "Primero selecciona un archivo")

    def send_program(self):
        command = 1
        self.last_command = command

        n_instructions = len(self.compiled)
        n_bytes = [self.split_instruction(self.compiled[i]) for i in range(0, n_instructions, 1)]
        self.uart.send_command(command)
        if self.uart.send_file(n_bytes):
            success_msg = f"Instrucciones enviadas correctamente. Total de instrucciones: {n_instructions} "
            messagebox.showinfo("Éxito", success_msg)
        print("Sent: ", commands.get(command))
        self.maximum_steps = n_instructions + 3
        self.open_read_file()  # Abrir ventana MIPS

    def open_read_file(self):
        self.ventana.withdraw()
        self.file_ventana = tk.Toplevel(self.ventana)
        self.file_ventana.geometry("900x500")
        self.file_ventana.configure(bg=self.bg_color)  # Fondo gris claro
        self.file_ventana.resizable(True, True)  # Ajustable

        self.file_ventana.title("MIPS")

        # Centrar el texto del PC
        self.pc_label = tk.Label(self.file_ventana, text="PC: No cargado", font=("Arial", 12), bg=self.bg_color, fg=self.fg_color)
        self.pc_label.pack(pady=10)

        # Frame para los widgets
        widgets_frame = tk.Frame(self.file_ventana, bg=self.bg_color)
        widgets_frame.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

        # Crear los widgets para el código ensamblador, banco de registros y memoria en una fila
        assembly_code_label = tk.Label(widgets_frame, text="Assembly Code", bg=self.bg_color, fg=self.fg_color)
        assembly_code_label.grid(row=0, column=0, padx=(0, 10), pady=5)

        self.text_widget = tk.Text(widgets_frame, wrap=tk.NONE, width=30, height=20, bg=self.bg_color, fg=self.fg_color)
        self.text_widget.grid(row=1, column=0, padx=5)
        self.text_widget.configure(state='normal')

        bank_register_label = tk.Label(widgets_frame, text="Bank Register", bg=self.bg_color, fg=self.fg_color)
        bank_register_label.grid(row=0, column=1, padx=(0, 10), pady=5)

        self.bank_register_text_widget = tk.Text(widgets_frame, wrap=tk.NONE, width=30, height=20, bg=self.bg_color, fg=self.fg_color)
        self.bank_register_text_widget.grid(row=1, column=1, padx=5)
        self.bank_register_text_widget.configure(state='normal')

        memory_label = tk.Label(widgets_frame, text="Memory", bg=self.bg_color, fg=self.fg_color)
        memory_label.grid(row=0, column=2, padx=(0, 10), pady=5)

        self.memory_text_widget = tk.Text(widgets_frame, wrap=tk.NONE, width=30, height=20, bg=self.bg_color, fg=self.fg_color)
        self.memory_text_widget.grid(row=1, column=2, padx=5)
        self.memory_text_widget.configure(state='normal')

        # Crear un Frame para contener los botones
        button_frame = tk.Frame(self.file_ventana, bg=self.bg_color)
        button_frame.pack(pady=5)

        # Botón para ejecución CONTINUA
        execute_continuous_button = tk.Button(button_frame, text="Ejecución CONTINUA", command=self.ejecucion_continua,
                                              bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))
        execute_continuous_button.grid(row=0, column=0, padx=10)

        # Botón para ejecución STEP
        execute_step_button = tk.Button(button_frame, text="Ejecución STEP", command=self.ejecucion_step,
                                        bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))
        execute_step_button.grid(row=0, column=1, padx=10)

        # Botón para volver a la pantalla principal
        back_button = tk.Button(button_frame, text="Volver", command=self.volver_principal,
                                bg=self.button_color, fg=self.button_fg_color, relief="raised", bd=2, font=("Arial", 12))
        back_button.grid(row=0, column=2, padx=10)

        # Aplicar efectos de hover a los botones
        self.apply_hover_effects(execute_continuous_button)
        self.apply_hover_effects(execute_step_button)
        self.apply_hover_effects(back_button)

        # Cargar contenidos iniciales
        self.load_initial_content()

    def volver_principal(self):
        """Cierra la ventana de MIPS y vuelve a la ventana principal."""
        self.file_ventana.destroy()
        self.create_main_widgets()
        self.ventana.deiconify()

    def load_initial_content(self):
        # Cargar contenido inicial en los widgets
        if self.selected_file:
            self.text_widget.configure(state='normal')
            with open(self.selected_file, 'r') as file:
                file_content = file.read()
                self.text_widget.delete(1.0, tk.END)
                self.text_widget.insert(tk.END, file_content)
            self.text_widget.configure(state='disabled')

        self.bank_register_text_widget.configure(state='normal')
        self.bank_register_text_widget.insert(tk.END, "Banco de Registros cargado aquí...")
        self.bank_register_text_widget.configure(state='disabled')

        self.memory_text_widget.configure(state='normal')
        self.memory_text_widget.insert(tk.END, "Memoria cargada aquí...")
        self.memory_text_widget.configure(state='disabled')

        # Actualizar PC con contenido inicial
        self.pc_label.config(text="PC: Valor inicial")

    def update_bank_register_text(self, new_text):
        self.bank_register_text_widget.configure(state='normal')
        self.highlight_changes(self.bank_register_text_widget, new_text, self.previous_bank_register)
        self.previous_bank_register = new_text.splitlines()  # Guardar el nuevo estado
        self.bank_register_text_widget.configure(state='disabled')

    def update_memory_text(self, new_text):
        self.memory_text_widget.configure(state='normal')
        self.highlight_changes(self.memory_text_widget, new_text, self.previous_memory)
        self.previous_memory = new_text.splitlines()  # Guardar el nuevo estado
        self.memory_text_widget.configure(state='disabled')

    def highlight_changes(self, text_widget, new_text, previous_text):
        """Resalta las líneas que han cambiado en un rojo más opaco."""
        new_lines = new_text.splitlines()
        for i, line in enumerate(new_lines):
            if i >= len(previous_text) or line != previous_text[i]:
                text_widget.insert(f"{i + 1}.0", line + "\n", "changed")
            else:
                text_widget.insert(f"{i + 1}.0", line + "\n")
        text_widget.tag_configure("changed", foreground=self.change_highlight_color)

    def update_pc_text(self, new_text):
        """Actualiza el valor del PC, mostrando también el contador de ciclos."""
        try:
            # Extraer solo la parte del texto correspondiente a "Hex"
            pc_value_hex = new_text.split('\t')[1].split(':')[1].strip()
            pc_value_dec = int(pc_value_hex, 16)  # Convertir a decimal
            
            # Actualizar etiqueta de PC con el valor actual y el contador de ciclos
            self.pc_label.config(
                text=f"PC (Dec): {pc_value_dec} | PC (Hex): {pc_value_hex} | CC: {self.cycle_count}"
            )
            
            # Incrementar el contador de ciclos
            self.cycle_count += 1
        except ValueError:
            self.pc_label.config(text="PC: Error en el formato de datos")  # Manejar error en la conversión

    def update_line_numbers(self):
        if hasattr(self, 'line_numbers'):
            line_count = self.text_widget.index(tk.END).split(".")[0]
            line_numbers = '\n'.join(map(str, range(1, int(line_count))))
            self.line_numbers.config(state=tk.NORMAL)
            self.line_numbers.delete(1.0, tk.END)
            self.line_numbers.insert(tk.END, line_numbers)
            self.line_numbers.config(state=tk.DISABLED)

    def compile_file(self):
        if self.selected_file:
            try:
                self.compiled = compilar(self.selected_file)
                print("Compilación exitosa.")
            except Exception as e:
                messagebox.showerror("Error", f"Error al compilar: {str(e)}")
        else:
            messagebox.showwarning("Advertencia", "Primero selecciona un archivo")

    def send_command(self):
        print(commands.get(self.option.get()))
        command = self.option.get()
        self.uart.send_command(command)

        if command == 1:
            self.next_action.get(command)()
        else:
            self.next_action.get(command)(commands_files.get(command)[0])

    def split_instruction(self, instruccion_binaria):
        if len(instruccion_binaria) != 32:
            raise ValueError("La instrucción debe tener 32 bits")
        
        palabras = [instruccion_binaria[i:i+8] for i in range(0, 32, 8)]
        return palabras

    def receive_file(self, file_size):
        command = self.option.get()
        print("Command: ", commands.get(command))
        self.uart.send_command(command)
        self.uart.receive_all(PC_SIZE, REGISTER_BANK_SIZE, mem_data_SIZE)

    def ejecucion_continua(self):
        command = 2
        self.uart.send_command(command)
        self.last_command = command
        msg = f'Cantidad de Ciclos: {self.sent_step} \n'
        print("Sent: ", commands.get(command))
        PC, BR, MEM = self.uart.receive_all(PC_SIZE, REGISTER_BANK_SIZE, mem_data_SIZE)
        self.update_bank_register_text(BR)
        self.update_memory_text(MEM)
        self.update_pc_text(PC)

    def ejecucion_step(self):
        if self.last_command == 1 or self.last_command == 2:  # Comprobar si el último comando fue escribir programa o ejecución continua
            command = 3  # Cambiar a modo step
            self.uart.send_command(command)
            print("Sent: ", commands.get(command))
        
        command = 4  # Ejecutar siguiente instrucción en modo step
        self.sent_step += 1
        self.uart.send_command(command)
        self.last_command = command

        print("Sent: ", commands.get(command))

        PC, BR, MEM = self.uart.receive_all(PC_SIZE, REGISTER_BANK_SIZE, mem_data_SIZE)
        self.update_bank_register_text(BR)
        self.update_memory_text(MEM)
        self.update_pc_text(PC)

if __name__ == '__main__':  
    gui = GUI()
