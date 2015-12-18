# numm

This is preliminary work for the NISO Uber Meta Model.

There are two directories here: numm/models and numm/xslt

Currently numm/models contains three fies:
  * jats1.xml - an xml representation of the numm properties of JATS 1.1d3.
  * bits1.xml - an xml representation of the numm properties of BITS 1.0.
  * bits1-test.xml - a copy of bits1.xml with changes that will fail the compatibility tests. 

There is one transform in numm/xslt: compare-models.xsl

This transform will compare a numm model XML for compatibility against a reference model. The JATS 1.1d3 model is set up as the default reference model in the transform with two stylesheet-level parameters and a variable:

```xml
 <xsl:param name="refpath" select="'https://raw.githubusercontent.com/jeffbeckncbi/numm/master/models/'"/>
 <xsl:param name="reffile" select="'jats1.xml'"/>
          
<xsl:variable name="refdoc" select="doc(concat($refpath,$reffile))"/>
```
By default the JATS 1.1d3 numm model will be used from this GitHub repository, but you can pass in a $refpath and $reffile to the transform to compare your numm model against any reference model you like. 

Running this transform on a numm xml model will compare it with the reference model. If the model is compatible with the reference model, the tranform will return a message that the nodels are compatible. If any of the tests fail, it will return a message that the model is not compatible with the reference model and give details on the specific tests that have failed. 

The specific tests are:

1. **Attribute type changes:** Only two attribute types are tracked in numm: ID and IDREF. A change in the value of any ID or IDREF attribute from the reference model will be an error. For example, if @rid is defined as IDREF in the reference model and it is changed to CDATA in the extension, the extension will NOT be comaptible with the reference model.

2. **Superstructure element changes"** Some elements are defined as "superstructure" elements. These are elements that define the general skeleton of the document that the content hangs on. For example, for HTML, &lt;html>, &lt;head>, and &lt;body> would be superstructure elements. 
Any element defined as a Superstructure element in the reference model must be a Superstructure element in the extension model. Also, any element that is not a Superstructure element in the reference model should not become a Superstructure element in the extension

3. **Element only or #PCDATA/EMPTY Model:** In numm we distinguish between elements that have only element content or elements that allow #PCDATA, Mixed Content, or are EMPTY. If an element changes it's "Element Only" status between the extension and the reference model, the extension is not compatible with the reference model. 

4. **Seciton Model Status Change:** The section is an important structure in documents. Generally a section consits of opening metadata (Head elements), block-level items (paragraphs, lists, etc), repeatable recursive sections, and closing metadata (Tail elements). If an element has this general structure it is said to have a "Section Model". If an elemnt had a section model in the reference model and no longer has one in the extension - or if an element gains a Section Model - the extension is not considered to be conforming to the reference model. 

5. **Alternatives Model Change:** Some elements are containers that hold different representations of the same item. The item could be different markup of a formula, names in different languages, or different quality images for a figure. These elements have the "Alternatives" property. If an element's "Alternatives" value changes between the reference model and the extension, then the extension is not conforming with the reference model. 

6. **"Points with @rid" Changes:** Some elements reference other elements in the same XML document with an IDREF attribute. If an element in the reference model can point to other elements, this property should be maintained in the extension. If it is not maintained, then the extension is not conforming with the reference model. Pointers from elements in the reference model MAY BE added to those elements in the extension and the extension would still conform. 

7. **Role in Section Changes:** Elements that are allowed to appear in sections fit into four categories: opening metadata (Head elements), block-level items (paragraphs, lists, etc), repeatable recursive sections, and closing metadata (Tail elements). 
  - Elements may GAIN a role-in-section.
  - Elements in the reference model with a role-in-section may be removed from the extension. 
  - An element may lose its role-in-section, but it may not change values for role-in-section. 
  - An extension must have at least one element whose role-in-section="section" 


There is one more stylesheet-level 
```xml
<xsl:param name="report" select="'no'"/>
```
$report will turn on the new objects report, which lists elements and attributes in the model that are not in the reference model.

## More Work

The hard part that we need to figure out next is how to write the numm xml for a model. Some of it can be generated by the DTD - or an XML version of the DTD - like the attribute entries, element-only model, section model (maybe?), and points-with-rid.

Information on whether an element is a Superstructure element or Alternatives will have to be added. It would be nice if we had a convention for including these properties into the source schema/documentation files. If we had this information there, we could generate the numm xml and do the comparison against the reference model.

If this becomes adopted, we will probably want to include these properties into the Tag Libraries (and the element/attribute definitions in the standard the next time we have to write those). 
