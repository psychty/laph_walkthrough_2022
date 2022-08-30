import React from 'react'
import ltla_df from '../wsx_values.json';
import styled from 'styled-components'; 

function Indicator_card() {
    return (
        <div>
            <h5>Indicators</h5>
            <div className='indicator_class'>
                    {ltla_df.map(indicator_item => (
                       <div>
                       {indicator_item.significance === 'section_circle' &&
                        <Card_item key={indicator_item.Indicator_Name}>
                            <CircleItemDiv className={indicator_item.significance}>
                                {indicator_item.Indicator_Name}
                            </CircleItemDiv>
                        </Card_item>
                        }

                        {indicator_item.significance !== 'section_circle' &&
                        <Card_item key={indicator_item.Indicator_Name}>
                            <CircleItemDiv className={indicator_item.significance}>
                                {indicator_item.significance}
                            </CircleItemDiv>
                            <h4> {indicator_item.Indicator_Name}</h4> 
                            <p>{indicator_item.Value}</p>
                        </Card_item>
                        }

                                   
                           
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
   max-width: 10vw;
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