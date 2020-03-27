//TicTacToe

#include <iostream>

struct TicTacToeGame
{
    int n = 3;
    int len = n * n;
    char board[9];
    char turn;
    int r; //row
    int c; //col
    //char winner; //X or O or ' ' for draw
    int move;
    bool xWin = 0;
    bool oWin = 0;
    bool tie = 0;
};


void printSeperator(const TicTacToeGame & g)
{
    std::cout << "\n+";
    for (int i = 0; i < g.n; ++i)
    {
        std::cout << "-+";
    }
    std::cout << "\n";
}


void print(const TicTacToeGame & g)
{
    //have to make algorithm for line len
    printSeperator(g);
    for (int i = 0; i < (g.n * g.n); ++i)
    {
        if (i >= g.n && (i % g.n == 0))
        {
            std::cout << "|";
            printSeperator(g);
        }
        std::cout << '|';
        std::cout << g.board[i];
    }
    std::cout << "|";
    printSeperator(g);
}


void init(TicTacToeGame & g)
{
    for (int i = 0; i < (g.n * g.n); ++i)
    {
        g.board[i] = ' ';
    }
    g.turn = 'X';
}


void get_move(TicTacToeGame & g)
{
    bool valid = 0;
    while (!valid)
    {
        std::cout << "Player " << g.turn << "'s move: ";
        std::cin >> g.r >> g.c;
        g.move = g.r * g.n + g.c;
        
        //make sure row and col don't go over n and spot is empty
        if (g.board[g.move] == ' ' && g.r < g.n && g.c < g.n) valid = 1;
    }
}

void make_move(TicTacToeGame & g)
{
    get_move(g);
    g.board[g.move] = g.turn;
}

void switch_turn(TicTacToeGame & g)
{
    g.turn = (g.turn == 'X' ? 'O' : 'X');
}


bool rightDiagWin(TicTacToeGame & g)
{
    g.xWin = 1;
    g.oWin = 1;
    for (int i = 0; i < g.len; i += (g.n + 1))
    {
        if (g.board[i] != 'X') g.xWin = 0;
        if (g.board[i] != 'O') g.oWin = 0;
    }
    if (g.xWin || g.oWin) return 1; 
    return 0;
}


bool leftDiagWin(TicTacToeGame & g)
{
    g.xWin = 1;
    g.oWin = 1;
    for (int i = (g.n - 1); i < (g.len - 1); i += (g.n - 1))
    {
        if (g.board[i] != 'X') g.xWin = 0;
        if (g.board[i] != 'O') g.oWin = 0;
    }
    if (g.xWin || g.oWin) return 1; 
    return 0;
}


bool rowWin(TicTacToeGame & g)
{
    g.xWin = 1;
    g.oWin = 1;
    for (int i = 0; i < g.len; ++i)
    {
        if (g.board[i] != 'X') g.xWin = 0;
        if (g.board[i] != 'O') g.oWin = 0;
        
        if ((i + 1) >= g.n && (i + 1) % g.n == 0)
        {
            if (g.xWin || g.oWin) return 1; 
            g.xWin = 1;
            g.oWin = 1;
        }
    }
    return 0;
}


bool colWin(TicTacToeGame & g)
{
    g.xWin = 1;
    g.oWin = 1;
    for (int i = 0; i < g.n; ++i)
    {
        for (int j = i; j < g.len; j += g.n)
        {
            if (g.board[j] != 'X') g.xWin = 0;
            if (g.board[j] != 'O') g.oWin = 0;
        }
        
        if (g.xWin || g.oWin) return 1; 
        g.xWin = 1;
        g.oWin = 1;
    }
    return 0;
}


bool tie(TicTacToeGame & g)
{
    g.tie = 1;
    g.xWin = 0;
    g.oWin = 0;
    for (int i = 0; i < g.len; ++i)
    {
        if (g.board[i] == ' ') g.tie = 0;
    }
    if (g.tie) return 1;
    return 0;
}


bool game_ended(TicTacToeGame & g)
{
    //Checks right diagonal \ WORKS
    if (rightDiagWin(g)) return 1;

    //checks left diagonal / WORKS
    if (leftDiagWin(g)) return 1;

    //Checks rows  WORKS
    if (rowWin(g)) return 1;
    
    //Checks cols WORKS
    if (colWin(g)) return 1;
    
    //Checks if spots are full
    if (tie(g)) return 1;
    
    return 0;
}

bool bot(TicTacToeGame & g)
{
    std::cout << "Player " << g.turn << "'s move: \n";
    //O win
    for (int i = 0; i < g.len; ++i)
    {
        if (g.board[i] == ' ')
        {
            g.board[i] = g.turn;
            if (game_ended(g))
            {
                return 1;
            }
            else
            {
                g.board[i] = ' ';
            }
        }
    }

    //Block X
    for (int i = 0; i < g.len; ++i)
    {
        if (g.board[i] == ' ')
        {
            g.board[i] = 'X';
            if (game_ended(g))
            {
                g.board[i] = 'O';
                return 0;
            }
            else
            {
                g.board[i] = ' ';
            }
        }
    }
    
    //First open
    for (int i = 0; i < g.len; ++i)
    {
        if (g.board[i] == ' ')
        {
            g.board[i] = g.turn;
            break;
        }    
    }
}


void botFirst(TicTacToeGame & g)
{
    int place = g.len / 2;
    if (g.len % 2 == 0)
    {
        place -= g.n / 2 + 1;
    }
    
    g.board[place] = 'O';
}

int main()
{
    //int n = 0;
    //std::cin >> n;
    //char board[n * n];
    TicTacToeGame game;
    init(game);
    botFirst(game);
    while (!game_ended(game))
    {
        print(game);
        if (game.turn == 'O') bot(game);
        if (game_ended(game)) break;
    
        if (game.turn == 'X') make_move(game);
        if (game_ended(game)) break;
        switch_turn(game);
    }
    print(game);
    
    if (game.xWin)
    {
        std::cout << "X Wins!\n";
    }
    else if (game.oWin)
    {
        std::cout << "O Wins!\n";
    }
    else if (game.tie)
    {
        std::cout << "Draw!\n";
    }
    //print winner name or draw
    //print_winner(game);
    return 0;
}
