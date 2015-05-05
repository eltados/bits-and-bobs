
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * A class for building up sql queries.
 * 
 * Simple class taken from this clog: <a
 * href="http://john.krasnay.ca/2010/02/15/building-sql-in-java.html"
 * <a>http://john.krasnay.ca/2010/02/15/building-sql-in-java.html</a>
 * 
 * @author slc
 * 
 */
public class SelectBuilder {

	private Integer limit = null;

	private final List<String> columns = new ArrayList<String>();

	private final List<String> tables = new ArrayList<String>();

	private final List<String> joins = new ArrayList<String>();

	private final List<String> leftJoins = new ArrayList<String>();

	private final List<String> wheres = new ArrayList<String>();

	private final List<String> orderBys = new ArrayList<String>();

	private final List<String> groupBys = new ArrayList<String>();

	private final List<String> havings = new ArrayList<String>();

	/**
	 * Default constructor.
	 */
	public SelectBuilder() {
	}

	/**
	 * A constructor that taken in a single table to query.
	 * 
	 * @param table the table to query.
	 */
	public SelectBuilder( String table ) {
		tables.add( table );
	}

	/**
	 * Appends a list of values to the sql.
	 * 
	 * @param sql The currect sql
	 * @param list The list of values to add
	 * @param init Any string to append before the first value.
	 * @param sep A seperator before following values
	 */
	private static void appendList( StringBuilder sql, List<String> list, String init,
	    String sep ) {
		boolean first = true;
		for ( String s : list ) {
			if ( first ) {
				sql.append( init );
			}
			else {
				sql.append( sep );
			}
			sql.append( s );
			first = false;
		}
	}

	/**
	 * Add a column to the instance.
	 * 
	 * @param name the name of the column
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder column( String name ) {
		return columns( name, (String[]) null );
	}

	/**
	 * Add multiple columns to select from.
	 * 
	 * @param name the first column
	 * @param names other columns
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder columns( String name, String ... names ) {
		columns.add( name );
		if ( names != null && name.length() > 0 ) {
			columns.addAll( Arrays.asList( names ) );
		}
		return this;
	}

	/**
	 * Add a column and also group by.
	 * 
	 * @param name the name of the column
	 * @param groupBy boolean, to group by.
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder column( String name, boolean groupBy ) {
		columns.add( name );
		if ( groupBy ) {
			groupBys.add( name );
		}
		return this;
	}

	/**
	 * Add a from clause with the table.
	 * 
	 * @param table the table to add to the from clause.
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder from( String table ) {
		tables.add( table );
		return this;
	}

	/**
	 * Add a where clause.
	 * 
	 * @param expr the where clause expression.
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder where( String expr ) {
		wheres.add( expr );
		return this;
	}

	/**
	 * Add a group by expression.
	 * 
	 * @param expr the group by expression.
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder groupBy( String expr ) {
		groupBys.add( expr );
		return this;
	}

	/**
	 * Adds a having clause.
	 * 
	 * @param expr The having expression.
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder having( String expr ) {
		havings.add( expr );
		return this;
	}

	/**
	 * Adds a join clause to the given table.
	 * 
	 * @param join the join clause including ON
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder join( String join ) {
		joins.add( join );
		return this;
	}

	/**
	 * Adds a left join clause to the given table.
	 * 
	 * @param join the join clause including ON
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder leftJoin( String join ) {
		leftJoins.add( join );
		return this;
	}

	/**
	 * Adds an order by clause to the query..
	 * 
	 * @param name the name to order by.
	 * @return the current {@link SelectBuilder} for chaining.
	 */
	public SelectBuilder orderBy( String name ) {
		orderBys.add( name );
		return this;
	}

	@Override
	public String toString() {

		StringBuilder sql = new StringBuilder( "SELECT " );

		if ( columns.size() == 0 ) {
			sql.append( "*" );
		}
		else {
			appendList( sql, columns, "", ", " );
		}

		appendList( sql, tables, " FROM ", ", " );
		appendList( sql, joins, " JOIN ", " join " );
		appendList( sql, leftJoins, " LEFT JOIN ", " left join " );
		appendList( sql, wheres, " WHERE ", " and " );
		appendList( sql, groupBys, " GROUP BY ", ", " );
		appendList( sql, havings, " HAVING ", " and " );
		appendList( sql, orderBys, " ORDER BY ", ", " );

		if ( limit != null ) {
			sql.append( " LIMIT " ).append( limit );
		}

		return sql.toString();
	}

	/**
	 * @param limitVal A value to add a limit clause at the end of the query.
	 * @return The builder.
	 */
	public SelectBuilder limit( Integer limitVal ) {
		this.limit = limitVal;
		return this;
	}
}
