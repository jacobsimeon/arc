require 'spec_helper.rb'

module Arc
  describe Hash do
    describe '#symbolize_keys!' do
      def hash
        @hash ||= {
          'superheros' => { 
            'batman' => {
              'whiny' => true,
              'actual_powers' => nil 
            },
            'superman' => {
              'whiny' => 'so absolutely false',
              'actual_powers' => [
                'leaps tall buildings in single bound',
                'faster than speeding bullet'
              ]
            }
          }
        }
      end
      it 'symbolizes keys' do
        hash.symbolize_keys!
        hash.keys.should include(:superheros)        
      end
      it 'symbolizes keys recursively' do
        hash.symbolize_keys!
        hash[:superheros].keys.should include(:superman)
        hash[:superheros].keys.should include(:batman)
        hash[:superheros][:batman].keys.should include(:whiny)
        hash[:superheros][:superman].keys.should include(:actual_powers)
      end
    end
  end
end
