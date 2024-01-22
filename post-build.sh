#!/usr/bin/env bash
cd book
mv html/* ./
rmdir html
mv pdf/output.pdf ./peter-rabbit.pdf
rmdir pdf
mv "epub/The Tale of Peter Rabbit.epub" ./peter-rabbit.epub
rmdir epub
