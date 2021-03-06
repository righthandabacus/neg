#--
# Copyright (c) 2012-2013, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


module Neg

  class NegError < StandardError; end

  class ParserError < NegError; end

  class ParseError < NegError

    attr_reader :tree, :offset

    def initialize(input, tree)

      @input = input
      @tree = tree
      @nodes = list_nodes(tree)

      @position = nil

      d = deepest_error
      @offset = d[1]
      super(d[3])
      #super("#{d[3]} at line #{line} col #{column}")
    end

    def errors

      @nodes.select { |n| n[2] == false && n[3].is_a?(String) }
    end

    def deepest_error

      # let's keep the tree depth (e[5]) for later

      errors.inject do |eold, enew|
        eold[1] <= enew[1] ? enew : eold
      end
    end

    def position

      @position ||= @input.position(@offset)
    end

    def line;    position[1]; end
    def column;  position[2]; end

    protected

    def list_nodes(start, depth=0, accumulator=[])

      start = start.dup
      start << depth

      accumulator << start
      start[4].each { |n| list_nodes(n, depth + 1, accumulator) }

      accumulator
    end
  end
end

