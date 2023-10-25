setup_bd_Paciente:- 
	consult('./bd_Paciente.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

cadastraPaciente :-
    setup_bd_Paciente,
    printLine,
    writeln("CADASTRO NOVO PACIENTE"),
    printLine,
    writeln("Digite seus dados: "),

    nl, writeln("Nome: "),
    read_line_to_string(user_input, Nome),

    nl, writeln("CPF: "),
    read_line_to_string(user_input, CPF),

    nl, writeln("Telefone: "),
    read_line_to_string(user_input, Telefone),

    nl, writeln("Peso: "),
    read_line_to_string(user_input, Peso),

    nl, writeln("Idade: "),
    read_line_to_string(user_input, Idade),

    nl, writeln("Grupo Sanguineo: "),
    read_line_to_string(user_input, GP),

    nl, writeln("Email: "),
    read_line_to_string(user_input, Email),

    nl, writeln("Senha: "),
    read_line_to_string(user_input, Senha),

    nl,
    (get_emails_paciente(Emails), member(Email, Emails) ->
        writeln("Email ja cadastrado."),
        nl;
        assertz(paciente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha)),
        adicionaPaciente,
        writeln("Paciente cadastrado com sucesso!"),
        nl
    ),
    fimMetodo.

adicionaPaciente :-
	setup_bd_Paciente,
	tell('./bd_Paciente.pl'), 
	nl,
	listing(paciente/8),
	told.


get_emails_paciente(Emails) :- 
	findall(Email, paciente(_,_,_,_,_,_,Email,_), Emails).

loginPaciente(Email) :-
	nl,
	writeln("Insira seu email: "),
	read_line_to_string(user_input, Email),
	writeln("Insira sua senha: "),
	read_line_to_string(user_input, Senha),
	(cliente(_, Email, Senha, _) -> nl, writeln("Login realizado com sucesso!"), nl;
	writeln("Senha incorreta."), nl, false).

login_paciente(Email) :-
	setup_bd,
	arquivo_vazio -> writeln("Paciente não cadastrado."), nl, false;
	(paciente(_, _, _, _) -> loginPaciente(Email);
	writeln("Paciente não cadastrado."), nl, false),
	fimMetodo.

fimMetodo:-
	writeln("Clique em enter para continuar: "),
	read_line_to_string(user_input, _).

%------------------------------------------------------------------------------------------------------
	listarPacientes:- 
		setup_bd_Paciente,
		findall(N, Paciente(N,_,_), ListaDePaciente), 
		exibirListaDePaciente(ListaDePaciente), 
		told,
		fimMetodo.
	
		exibirListaDePaciente([H|T]):-
		writeln(H),
		exibirListaDePaciente(T).
	
		exibirListaDePaciente([]).
	
	removePaciente:-
		nl,
		writeln("Insira o Nome do paciente a ser excluido: "),
		read_line_to_string(user_input, Nome),
		retornaListaDePaciente(Lista),
		removePacienteAux(Lista, Nome, ListaAtualizada),
		retractall(Paciente(_,_,_)),
		adicionaListaPaciente(ListaAtualizada),
		tell('./bd_Paciente.pl'),  nl,
		listing(medico/3),
		told,
		fimMetodo.
	
	retornaListaDePaciente(Lista):-
		findall([Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha], Paciente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha), Lista).
	
	adicionaListaPaciente([]). 
	
	adicionaListaPaciente([[Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha] | T]):-
		addPaciente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha), adicionaListaPaciente(T).
	
	addPaciente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha):-
		assertz(Paciente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha)).
	
		removePacienteAux([H|_], Nome, _) :-
			member(Nome, H),
			!.
		
			removePacienteAux([H|T], Nome, [H|Retorno]) :-
				removePacienteAux(T, Nome, Retorno).
		
			removePacienteAux([], _, []) :-
			nl, writeln("Paciente informado não existe!"), nl.
	
	visualizarAgendamentos(Medico, List):-
		bd_Agendamento,
		findall([Medico, Paciente, Horario, Status], agendamento(Medico, Paciente, Horario, Status), List),
		told.
	
	visualizarAgendamentosPendentes(Medico, List) :-
		bd_Agendamento,
		findall([Medico, Paciente, Horario, Status], (agendamento(Medico, Paciente, Horario, Status), Status == "Pendente"), List),
		told.
		
			
	
	fimMetodo:-
		writeln("Clique em enter para continuar: "),
		read_line_to_string(user_input, _).
	