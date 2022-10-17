import React, {useRef} from 'react'
import ltla_df from '../wsx_values.json';
import styled from 'styled-components'; 
import Xarrow from "react-xarrows";

const boxStyle = {border: "grey solid 2px", borderRadius: "10px", padding: "5px"};

function Indicator_card() {

    const box1Ref = useRef(null);

    return (
        <div>
            <h5>West Sussex compared to England; updated September 2022</h5>
            <div className='indicator_class'>
                    {ltla_df.map(indicator_item => (
                       <div id={indicator_item.ID}>

                        {/* If the object is section_circle just show the indicator name */}
                       {indicator_item.significance === 'section_circle' &&
                        <Card_item key={indicator_item.Indicator_Name} id= {indicator_item.Sex}>
                            <CircleItemDiv className={indicator_item.significance}>
                                {indicator_item.Indicator_Name}
                            </CircleItemDiv>
                        </Card_item>
                        }
                        
                        {/* If the object is an indicator then show the circles, value and label */}
                        {indicator_item.significance !== 'section_circle' &&
                        <Card_item key={indicator_item.Indicator_Name}>
                            <CircleItemDiv className={indicator_item.significance}>
                                {indicator_item.significance}
                            </CircleItemDiv>
                            <h4> {indicator_item.Value}</h4> 
                            <p>{indicator_item.Indicator_Name}</p>
                        </Card_item>
                        }

                    {/* do we need to give each box and id (ascending and then look through)*/}
                    <Xarrow start="11202" end="20401"/>  
                    <Xarrow start='21001' end = '22001' color="red" dashness={true} path = 'straight'/>
                           
                    </div>
                    ))}
            </div>
        </div>
    )
}

const CircleItemDiv = styled.div `
display: flex;
align-items: center;
justify-content: center;
flex-wrap: wrap;
padding: 5px;
margin: 3px;
`

const Card_item = styled.div `
   max-width: 5vw;
   padding: 5px;
   padding-left: 10px;
   border-radius: 25px;
   border: 1px solid #c9c9c9;
   display: flex;
   align-items: center;
   justify-content: center;
   flex-wrap: wrap;

   p{
    margin-top: 5px;
    font-size: .7rem;
   }

   h4{
    margin-top: 5px;
    font-size: .8rem;
 } `

export default Indicator_card