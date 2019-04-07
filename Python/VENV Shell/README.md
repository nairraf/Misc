# VENV Shell

## Overview

VENV Shell is a minimalistic way of opening a python Shell for a specific VENV.
All that is needed is to create an environment varible called "VENV" that points
to the parent directory where all your VENV's are created.

Example:
    Let's say all your Python VENV's are created in C:\Python\VENV.
    Create an environment varialble called VENV pointing to C:\Python\VENV

The script detects all the VENV's in that location, and prompts you with a simple
menu to activate one of them. This way you can easily open as many shells as you
want in any VENV that you want.

I know that there are numerous ways of dealing with python VENV, but I just wanted
to use default python VENV's, and have an easy way of opening a shell to any one
of the VENV's.

## Installation

Installation is really easy. all that is needed is to download into a directory
of your choosing, and then double click CreateShortcut.vbs, which will detect
the current directory, and create the shortcut to VENVShell.ps1. From there, simply
Right click the "VENV Shell" shortcut and choose "Pin to Start Menu" if your on
Windows 10. Then you can easily launch a python shell for any configured VENV

## Notice

Python Icon take from: http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team/python-icon.html 
