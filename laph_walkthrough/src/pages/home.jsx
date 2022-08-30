import React from 'react';
import Introductory_text from '../components/introductory_text';
import Indicator_card from '../components/indicator_card';
import Comparison_key from '../components/comparison_key';

function Home() {
    return (
        <div>
           <Introductory_text />
           <Comparison_key />
           <Indicator_card />
        </div>
);
}

export default Home