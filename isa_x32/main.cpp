// Nome: Kyara Esteves de Sousa
// Mat: 0825298

#include <bits/stdc++.h>

using namespace std;

int errors_number = 0;
unordered_map<string, int> opcodes
{
    {"add", 1},
    {"sub", 2},
    {"mult", 3},
    {"div", 4},
    {"jmp", 5},
    {"jmpn", 6},
    {"jmpp", 7},
    {"jmpz", 8},
    {"copy", 9},
    {"load", 10},
    {"store", 11},
    {"input", 12},
    {"output", 13},
    {"stop", 14}
};

unordered_map<string, int> opcodes_size
{
    {"add", 1},
    {"sub", 1},
    {"mult", 1},
    {"div", 1},
    {"jmp", 1},
    {"jmpn", 1},
    {"jmpp", 1},
    {"jmpz", 1},
    {"copy", 1},
    {"load", 1},
    {"store", 1},
    {"input", 1},
    {"output", 1},
    {"stop", 1}
};

bool read_arguments(int argc, char **argv, string &argument, string &assembly_file,string &object_file) {

    bool error = true;
    if (argc != 4) error = true;
    else {

        argument = argv[1];
        if (argument != "-p" &&
            argument != "-m" &&
            argument != "-o") {

            error = true;
        }else {

            assembly_file = argv[2];
            object_file = argv[3];

            error = false;
        }
    }

    return !error;
}

void copy_file(string source, string destination) {
    ifstream file_source(source);
    ofstream file_target(destination);
    string line;
    while (getline(file_source, line)) {
        file_target << line << endl;
    }

    file_source.close();
    file_target.close();
}

string pre_process_directives(string assembly_file) {
    string file_directives_processed = assembly_file+".p";

    copy_file(assembly_file, file_directives_processed);
    //cout << "file returned after directives preprocessed " << file_directives_processed << endl;

    ifstream file_source(assembly_file);
    string  line;
    vector<string> lines, aux_lines;

    while (getline(file_source, line)) {
        lines.push_back( line + "\n");
    }
    file_source.close();

    // converte todas as letras para minusculo
    for(auto line: lines) {
        string aux_line = line;

        transform(line.begin(), line.end(), aux_line.begin(), ::tolower);
        aux_lines.push_back(aux_line);
    }

    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();

    // remove os comentarios
    for(auto line: lines) {
        int commentary_pos = line.find(";");
        if ( commentary_pos >= 0) {
            string aux_line = line;

            aux_line.erase(commentary_pos);

            aux_line+="\n";
            aux_lines.push_back(aux_line);

        } else {
            aux_lines.push_back(line);

        }
    }

    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();

    // remove as linhas em branco e as linhas com apenas espacos
    for(auto line: lines) {
        string aux_line = line;
        if (aux_line == "\n") {
            continue;
        } else {
            bool has_nothing = true;

            for(int i = 0; i<(int)aux_line.size(); i+=1) {
                //cout << aux_line[i] << endl;
                char c = aux_line[i];
                //cout << c;
                if (c != ' ' && c != '\n' ) {
                    has_nothing = false;
                    //cout <<" s " << endl;
                }
            }
            if (has_nothing == true) {
                continue;
            } else {
                aux_lines.push_back(aux_line);

            }

        }
    }

    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();

    // remove espacos repetidos e espacos de fim de linha
    for (auto line: lines) {
        stringstream aux_str(line);
        string aux_line ="", real_word="";
        while (aux_str >> real_word) {
            aux_line += real_word +" ";

        }
        aux_line += "\n";
        aux_lines.push_back(aux_line);
    }



    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();


    // remove a virgula(,) das instrucoes copy
    for(auto line: lines) {
        string aux_line = line;

        int pos_comma = aux_line.find(",");
        if (pos_comma >=0) {
            //cout << pos_comma << endl;
            aux_line.erase(pos_comma, 1);
        }


        aux_lines.push_back(aux_line);
        //cout << aux_line << endl;
    }

    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();


    // remove todos os rotulos que estao sozinhos na linha e
    // coloca eles na proxima linha
    string rotulo = "";
    for (auto line: lines) {
        if (line.find(":") == line.size()-3) {
            rotulo = line;
            rotulo.erase(rotulo.find("\n"));
        } else {
            string aux_line = rotulo + line;
            aux_lines.push_back(aux_line);
            rotulo = "";
        }

        // aux_lines.push_back(line);
    }

    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();

    // remove as linhas com rotulo: EQU valor e processa as IF rotulo
    unordered_map<string, int> labels; // apenas rotulo: EQU valor
    unordered_map<string, int> labels_line;
    bool execute_line = true;
    vector<string> words;
    string real_word;
    int line_number = 1;
    unordered_set<string> labels_used;
    for(auto line: lines) {
            stringstream aux_string(line);
            words.clear();
            while(aux_string >> real_word) {
                words.push_back(real_word);
            }

            /*
            for(int i =0; i < words.size(); i+=1) {
                cout <<"size: ";
                cout << "words["<<i<<"]= "<< words[i] << " ";
            }
            cout << endl;
            cout << endl;
            //aux_lines.push_back(line);
            */


            if (words[0].find(":") == words[0].size()-1) {

                if (words[1] == "equ") {
                    string key = words[0];
                    key.erase(words[0].size()-1);
                    labels[key] = stoi(words[2]);
                    labels_line[key] = line_number;
                } else {
                    aux_lines.push_back(line);
                }
            } else if (words[0] == "if") {
                string key = words[1];
                //cout<<"key: "<< key << endl;
                //cout << labels[key] << endl;
                auto got = labels.find(key);
                if (got == labels.end()) {
                    cout << "linha " << line_number <<" (erro semantico): IF com rotulo nao declarado por um EQU" << endl;
                    errors_number += 1;
                } else{
                    //cout <<"finded, labels["<<key<<"]="<<labels[key]<<endl;

                    labels_used.insert(key);
                    if (  labels[key]  !=0  ){
                        execute_line = true;
                    } else {
                        execute_line = false;
                    }
                }
            } else {
                if (execute_line == true) {
                    aux_lines.push_back(line);
                } else if (execute_line == false) {
                    execute_line = true;
                }
            }
            line_number++;

    }
    /*
    for(auto x: labels) {
        cout << x.first <<" , " << x.second << endl;
    }
    */
    for(auto label: labels) {
        auto it = labels_used.find(label.first);
        if (it == labels_used.end()) {
            int line_number = labels_line[label.first];
            cout <<"linha "<< line_number <<" (erro semantico): EQU com rotulo nao utilizado" << endl;
            errors_number++;
        }
    }


    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();

    /*
    for(auto line: lines) {
        cout << line;
    }
    */

    // insere espacos reservados e constantes no final do arquivo
    vector<string> text, data;
    // primeiro nos separamos as instrucoes(text) dos dados(data) em vectors diferentes
    for(auto line: lines) {
        string aux_line = line;
        stringstream aux_string(line);
        string real_word;
        vector<string> words;
        words.clear();
        while(aux_string >> real_word) {
            words.push_back(real_word);
        }

        //cout << line << endl;
        // se isso é um rotulo entao verifica se depois vem dados ou instrucoes
        if (words[0].find(":") == words[0].size()-1) {
            if (words[1]=="space" || words[1] == "const") {
                data.push_back(aux_line);
            }else {
                text.push_back(aux_line);
            }
        } else {
            // essa linha é uma instrucao
            text.push_back(aux_line);
        }
    }

    // insere as instrucoes no aux_list vector
    for(auto line_text: text) {
            aux_lines.push_back(line_text);
    }

    // agora inserimos os dados no aux_list vector
    for(auto line_data: data) {
        aux_lines.push_back(line_data);
    }

    // atualiza vector lines
    lines.clear();
    for (auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();


    /*
    // show the final vector of strings
    for(auto line: lines) {
        cout << line;
    }
    */

    // escreve os elementos do vector lines no arquivo
    ofstream file_target(file_directives_processed);
    for(auto line: lines) {
        file_target << line;
    }

    file_target.close();
    return file_directives_processed;
}

string pre_process_macros(string assembly_file) {
    string file_directives_processed = pre_process_directives(assembly_file);
    string file_macros_processed;

    size_t end_pos =file_directives_processed.find(".p");
    string file_name_aux = file_directives_processed;
    file_name_aux.erase(end_pos, 2);
    file_name_aux += ".m";
    file_macros_processed  = file_name_aux;
    copy_file(file_directives_processed, file_macros_processed);

    // leia do arquivo e inicializa o vector lines
    vector<string> lines;
    ifstream file_source(file_macros_processed);
    string line;
    while(getline(file_source, line)) {
        lines.push_back(line+"\n");
    }
    file_source.close();

    vector<string> aux_lines;

    // acha a posicao do inicio e fim da macro no codigo
    int macro_start, macro_end = -1;
    string macro_name;
    int pos = 0;
    for(auto line: lines) {
        string aux_line = line;
        stringstream aux_string(line);
        string real_word;
        vector<string> words;
        words.clear();
        while(aux_string >> real_word) {
            words.push_back(real_word);
        }

        if (words[0].find(":") == words[0].size()-1) {
            if (words[1] =="macro") {
                string name_aux = words[0];
                name_aux.erase(words[0].find(":"));
                macro_name = name_aux;
                macro_start = pos;

            }
        } else if (words[0] == "endmacro") {
            macro_end = pos;
        }

        aux_lines.push_back(line);
        pos+=1;
    }

    if (macro_end == -1) {
        cout << "linha " << lines.size() << " (erro semantico): Falta ENDMACRO"<<endl;
        errors_number++;
    }

    //cout << "macro begin: " << macro_start << endl;
    //cout << "macro end: " << macro_end << endl;
    //cout <<"macro name: " << macro_name << endl;

    lines.clear();
    for(auto line: aux_lines) {
        lines.push_back(line);
    }
    aux_lines.clear();

    if (macro_end != -1) {
        bool macro_used = false;

        // inserimos o corpo da macro no codigo onde é necessario
        for(int pos_line=0; pos_line <(int)lines.size(); pos_line+= 1) {
            line = lines[pos_line];
            //cout << "line: " << line << endl;
            string aux_line;
            stringstream aux_string(line);
            string real_word;
            vector<string> words;
            words.clear();
            while(aux_string >> real_word) {
                words.push_back(real_word);
            }

            if (words[0] == macro_name+":") {
                pos_line = macro_end;
                continue;

            }
            if (words[0] == macro_name) {
                macro_used = true;
                for(int j=macro_start+1; j < macro_end; j+= 1) {
                    string macro_line = lines[j];
                    //cout << "macro line: " << macro_line << endl;
                    aux_lines.push_back(macro_line);
                }
            } else {
                aux_lines.push_back(line);
            }


        }

        if (macro_used == false) {
            cout <<"linha "<<lines.size()<<" (erro semantico): MACRO nao utilizada"<<endl;
        }

        // atualiza vector lines
        lines.clear();
        for(auto line: aux_lines) {
            lines.push_back(line);
        }
        aux_lines.clear();
    }

    // atualiza arquivo ao escrever o vector lines nele
    ofstream file_target(file_macros_processed);
    for(auto line: lines) {
        file_target << line;
    }
    file_target.close();
    //cout << "file returned after macros preprocessed: " << file_macros_processed << endl;
    return file_macros_processed;

}

void assembly(string assembly_file, string object_file) {
    string file_macros_processed = pre_process_macros(assembly_file);

    //size_t end_pos = file_macros_processed.find(".m");
    //file_macros_processed.erase(end_pos, 2);
    //cout << "file ready for be assembled: " << file_macros_processed << endl;

    // le do arquivo.m e insere as linhas no vector lines
    vector<string> lines, objects;

    ifstream source_file(file_macros_processed);
    string line;
    while (getline(source_file, line)) {
        lines.push_back(line+"\n");
    }

    source_file.close();

    // primeira passagem ---> contamos os enderecos e geramos a tabela de simbolos
    unordered_map<string, int> symbol_table;
    int address_pos = 0;
    int line_code = 1;
    for(auto line: lines) {
        string aux_line = line;
        stringstream aux_string(line);
        string real_word;
        vector<string> words;
        words.clear();
        while(aux_string >> real_word) {
            words.push_back(real_word);
        }

        bool found_instruction = false;
        int number_labels_line = 0;
        for(int pos = 0; pos<(int)words.size();pos+= 1) {

            // testamos se os tokens sao validos
            bool token_valid = true;
            if (words[pos].size() > 99) {
                token_valid = false;
            }

            if (words[pos][0] >= '0' && words[pos][0] <= '9') {
                token_valid = false;
            }

            for(int i = 0; i<(int)words[pos].size(); i++) {
                char a = words[pos][i];
                if (
                    !isalpha(a) && !isdigit(a) && a != '_' && a != ':'
                    )
                    {
                    //cout << "token " << a <<" is invalid" << endl;
                    token_valid = false;
                }
            }

            if (token_valid == false) {
                cout << "linha "<<line_code <<" (erro lexico): token invalido"<<endl;
                errors_number++;
            }


            // testa se é um rotulo
            if (words[pos].find(":")==words[pos].size()-1) {
                number_labels_line+= 1;

                // testa se existem dois rotulos por linha
                if (number_labels_line >= 2) {
                    cout <<"linha "<<line_code<<" (erro sintatico): Dois rotulos na mesma linha."<<endl;
                    errors_number+=1;
                }
                string key = words[pos].erase(words[pos].find(":"));

                auto it = symbol_table.find(key);
                if (it == symbol_table.end()) {
                    symbol_table[key] = address_pos;
                }else {
                    cout << "linha "<<line_code <<" (erro semantico): rotulo repetido"<<endl;
                    errors_number++;
                }

                if (words[pos+1] == "space" ) {
                    address_pos += 1;
                    pos+=1;
                } else if (words[pos+1] == "const") {
                    address_pos += 1;
                    pos+=2;
                }

            }else {

                // testa se é uma instrucao
                if (found_instruction == false) {
                    auto try_find = opcodes_size.find(words[pos]);
                    if (try_find != opcodes_size.end()) {
                        address_pos += opcodes_size[words[pos]];
                        found_instruction = true;

                    // testa se o número de operandos esta correto
                    int number_operands = words.size()-pos-1;
                    // pos é 1 ou 0 aqui
                    if (
                        (number_operands != 0 && words[pos] == "stop")||
                        (number_operands != 2 && words[pos] == "copy")||
                        (words[pos]!="stop"&&words[pos]!="copy"&&
                         number_operands != 1)
                        ){
                        cout << "linha "<<line_code <<" (erro sintatico): instrucao com quantidade de operandos invalido."<<endl;
                        errors_number++;
                        }

                    } else {
                        cout << "linha "<<line_code <<" (erro sintatico): instrucao "<<words[pos] <<" nao existe" << endl;
                        errors_number++;
                    }
                } else {
                    address_pos += 1;
                }
            }
        }


        line_code++;
    }

    /*
    cout << "symbol table: " << endl;
    // print  symbol table
    for(auto symbol: symbol_table) {
        cout << symbol.first << " : " << symbol.second << endl;
    }
    */


    // na segunda passagem geramos o arquivo objeto nao em binario mas em decimal
    address_pos = 0;
    line_code = 1;
    for(auto line: lines) {
        string aux_line = line;
        stringstream aux_string(line);
        string real_word;
        vector<string> words;
        words.clear();
        while(aux_string >> real_word) {
            words.push_back(real_word);
        }

        for(int pos=0; pos <(int)words.size(); pos+=1) {
            //cout << words[pos] << endl;
            // testa se é um rotulo com ":"
            if (words[pos].find(":") == words[pos].size()-1) {
                if (words[pos+1] == "space") {
                    objects.push_back("0 ");
                    address_pos += 1;
                    pos+= 1;
                }else if (words[pos+1] == "const") {
                    objects.push_back(words[pos+2]+" ");
                    pos+= 2;
                    address_pos += 1;
                } // aqui nao fazemos nada!

            } else { // testamos se é um rotulo sem  ":" ou uma instrucao
                auto it_instruction = opcodes.find(words[pos]);
                if (it_instruction != opcodes.end()) {
                    // é uma instrucao
                    int opcode = opcodes[words[pos]];
                    objects.push_back(to_string(opcode)+" ");

                    address_pos += opcodes_size[words[pos]];


                } else {
                    // nao é uma instrucao
                    // testa se é um label sem ":"
                    auto it_label = symbol_table.find(words[pos]);
                    if (it_label != symbol_table.end()) {
                        // encontrou um rotulo
                        int address = symbol_table[words[pos]];
                        objects.push_back(to_string(address)+" ");

                        address_pos += 1;
                    } else {
                        cout << "linha "<<line_code <<" (erro semantico): rotulo ausente." << endl;
                        errors_number++;
                    }
                }
            }
        }

        line_code++;
    }


    ofstream file_target(object_file);

    for(auto line: objects) {
        file_target << line;
    }

    file_target.close();
}


int main(int argc, char **argv) {
    string argument, assembly_file, object_file;

    if (read_arguments(argc, argv, argument,
                       assembly_file, object_file)==false) {
        cout << "Argumentos invalidos!" << endl;

    } else {
        //cout << "argumentos lidos e aceitos." << endl;
        cout << endl;

        if (argument == "-o") {
            assembly(assembly_file, object_file);
            //cout << endl;
            if (errors_number == 0) {
                    cout << "Codigo fonte montado com sucesso para o arquivo objeto: " <<
            object_file <<endl;
            } else {
                cout << "Codigo fonte com erros." << endl;
            }
        } else if (argument == "-p") {
            string file_name = pre_process_directives(assembly_file);
            cout << endl;
            cout << file_name << " gerado." << endl;
        } else if (argument == "-m") {
            string file_name = pre_process_macros(assembly_file);
            cout << endl;
            cout << file_name << " gerado." << endl;
        }
    }

    return 0;
}
