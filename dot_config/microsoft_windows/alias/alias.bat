@echo off

:: Meta
DOSKEY alias=notepad D:\.config\microsoft_windows\alias\alias.bat

:: Quality of Life?
DOSKEY ..=cd ..

:: Unix Like
DOSKEY clear=cls
DOSKEY ls=dir /D
DOSKEY which=where $*
:: DOSKEY wc=$b find /c /v ""

:: Programming
DOSKEY dotfiles=git --git-dir=%HOME%\.dotfiles\ --work-tree=%HOME% $*
DOSKEY python3=python