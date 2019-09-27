# VENV Shell

## Overview

VENV Shell is a minimalistic way of opening a python Shell for a specific `VENV`.
All that is needed is to create an environment varible called `PYTHON_VENV` that points
to the parent directory where all your `VENV`'s are created and another called `PYTHON_BASE`
pointing to the base directory where all your python versions are installed.

**Example**: Let's say all your Python `VENV`'s are created in `C:\Python\VENV` and all your
Python installation are in C:\Python (Example: 'C:\Python\Python2.7_32', 'C:\Python\Python3_64').
Create an environment varialble called `PYTHON_VENV` pointing to `C:\Python\VENV`
and PYTHON_BASE pointing to C:\Python.

The script detects all the virtual environment in that location, and prompts you
with a simple menu to activate one of them. This way you can easily open as many
shells as you want in any `VEN`V` that you want.

I know that there are numerous ways of dealing with python VENV, but I just 
wanted to use default python VENV's, and have an easy way of opening a shell to
any one of them.

## Installation

Installation is really easy. all that is needed is to download into a directory
of your choosing, and then double click CreateShortcut.vbs, which will detect
the current directory, and create the shortcut to VENVShell.ps1. From there,
simply right click the "VENV Shell" shortcut and choose "Pin to Start Menu" if
your on Windows 10. Then you can easily launch a python shell for any configured
`VENV`

## Notice

Python Icon take from: <https://icon-icons.com/icon/pearl-shell/98384>
