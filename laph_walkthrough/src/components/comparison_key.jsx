import React from 'react'
// import { useEffect, useState } from "react";
import styled from "styled-components";
// import { NavLink, useLocation} from 'react-router-dom';
import comparison_values_df from '../comparison_values.json';

function Comparison_key() {

// const location=useLocation()

    return (
        <div>
            <p>Each circle represents an outcome and you can hover hover and click on a circle to find out more.</p>
                
        <div className = 'sig_compare_buttons'>
            {comparison_values_df.map(circle => (

                <CompareItemDiv className = {circle.sig_class}>
                <p>{circle.sig_title}</p>
                </CompareItemDiv>
                      
                 ))}
            </div>
    
            <p>The colour of the circle shows the value for the chosen area compared with England (usually based on whether the 95% confidence intervals overlap). In some cases, a low value might be better (for example the rate of teenage pregnancies) and in other cases a higher value may be better (e.g. uptake of screening) and as such a green circle denotes that the value is significantly better than the value for England and a red value denotes that the value is significantly worse than England. A statistically similar value is denoted by a yellow circle. Where it is not appropriate to that a high or low value is better, or if it is not possible to compare against the national value, the circle will be coloured grey.</p>
            <p>You can also find the comparison by hovering over a circle.</p>
        </div>

); 

}

const CompareItemDiv = styled.div `
min-width: 85px;
min-height: 85px;
width: 5vw;
height: 5vw;
border-radius: 50%;
display: flex;
align-items: center;
justify-content: center;
flex-wrap: wrap;
padding: 5px;
margin: 3px;
`

export default Comparison_key