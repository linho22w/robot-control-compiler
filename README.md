# Robot Control Compiler

A small compiler front-end, lexer and parser, for a toy command language that drives a simulated robot arm on a 100×100 grid. Built with Flex and Bison for the Compilers course of my BSc in Computer Engineering at UTAD.

## 🎯 The language

The robot has a position, a facing direction, and a gripper ("pinça") that can point in any of 8 directions relative to the robot and can be opened or closed to pick up or drop an object. The language has one instruction per line:

| Command | Effect |
|---|---|
| `VIRAR-DIREITA` / `VIRAR-ESQUERDA` | Turn the robot (and gripper) 90° right / left |
| `ANDAR(n)` | Move forward `n` positions (1-100), blocked at the grid edge |
| `RODAR(g)` | Rotate the gripper by `g` degrees (multiple of 45, ±360) around the robot |
| `PINCA(ABRIR)` / `PINCA(FECHAR)` | Open / close the gripper, picking up or dropping an object underneath it |

## 🧱 Two versions, built incrementally

**`v1-lexer-only/`**, a Flex-only version. The lexer recognizes each instruction directly and calls C functions that update the robot's state as it scans, no parser involved. Good enough as long as the input is one valid instruction per line.

**`v2-lexer-parser/`**, the full version: Flex now just tokenizes, and a Bison grammar defines the actual program structure, a `BEGIN`/`END` block of comma-separated instructions, optionally starting with `INIT-OBJETO(x,y)` to place an object on the grid. This version adds proper error recovery (an `erros` production that counts bad lines and keeps going instead of stopping), and the gripper can now actually pick up and carry an object between positions.

```
BEGIN
{
INIT-OBJETO(40,60),
ANDAR(59),
VIRAR-DIREITA,
ANDAR(38),
PINCA(ABRIR),
PINCA(FECHAR),
...
}
END
```

## 🧠 How the gripper position works

The gripper doesn't have its own independent position, it's derived from the robot's position and the gripper's own facing direction (one of 8, vs. the robot's 4). Every time the robot turns or the gripper rotates, `PosicaoPinca()` recalculates where the gripper actually is on the grid relative to the robot, which is what lets `PINCA(FECHAR)` know whether it's actually on top of the object to pick it up.

## ▶️ Building and running

Needs `flex` and `bison` (or `yacc`).

**v1** (lexer only):
```bash
cd v1-lexer-only
flex robot.l
gcc lex.yy.c -o robot -lfl
./robot < test-input.txt
```

**v2** (lexer + parser):
```bash
cd v2-lexer-parser
bison -d robot.y
flex robot.l
gcc robot.tab.c lex.yy.c -o robot -lfl
./robot < test-input.txt
```

## 🛠️ Tech Stack

<p align="center">
  <img src="https://skillicons.dev/icons?i=c" />
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Flex-37474F?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Bison%20%2F%20YACC-6A1B9A?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Lexical%20Analysis-00897B?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Parsing-2496ED?style=for-the-badge" />
</p>

## 👤 About

Part of my portfolio. See my [GitHub profile](https://github.com/linho22w) for more projects in AI/ML and backend development.
