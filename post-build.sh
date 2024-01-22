#!/usr/bin/env bash
cd build
mv html/* ./
rm html
mv pdf/output.pdf ./peter-rabbit.pdf
rm pdf
mv "epub/The Tale of Peter Rabbit.epub" ./peter-rabbit.epub
rm epub
