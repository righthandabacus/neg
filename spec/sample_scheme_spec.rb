
require 'spec_helper'


describe 'sample scheme parser' do

  class SchemeParser < Neg::Parser

    parser do

      expression == list | atom

      list == `(` + (expression + (` ` + expression) * 0) * 0 + `)`
      atom == _("^() ") * 1
    end

    translator do

      on(:expression) { |n| n.results.first }
      on(:atom) { |n| n.result }

      on(:list) { |n| n.flattened_results }
    end
  end

  it 'parses numbers' do

    SchemeParser.parse("13").should == "13"
    SchemeParser.parse("-13").should == "-13"
  end

  it 'parses lists' do

    SchemeParser.parse("()").should == []
    SchemeParser.parse("(a b c)").should == [ 'a', 'b', 'c' ]
    SchemeParser.parse("(a (b c))").should == [ 'a', [ 'b', 'c' ] ]
  end
end

